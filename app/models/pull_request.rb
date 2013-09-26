class PullRequest < ActiveRecord::Base
  belongs_to :repo
  has_one :provisioned_mysql, dependent: :destroy
  has_one :provisioned_nginx, dependent: :destroy
  has_one :provisioned_redis, dependent: :destroy

  before_destroy :destroy_build

  attr_accessible :author,
                  :branch,
                  :title,
                  :github_updated_at,
                  :status,
                  :provisioned_mysql,
                  :provisioned_nginx,
                  :provisioned_redis,
                  :jira_status_name,
                  :jira_status_icon_url

  def sync_with_jira(client)
    return unless !!jira_issue && jira_issue != ""
    issue = client.Issue.find(jira_issue)
    if !!issue
      update_attributes(
        jira_status_name: issue.status.name,
        jira_status_icon_url: issue.status.iconUrl
      )
    end
  end

  def comment_on_jira_issue(client)
    return unless !!jira_issue && jira_issue != ""
    issue = client.Issue.find(jira_issue)
    if !!issue
      comment = issue.comments.build
      comment_body = "A pull request has been created for this issue: #{url}"
      if repo.should_provision_nginx
        comment_body += "\n\nView website: http://#{website}"
      end
      comment.save({'body' => comment_body})
    end
  end

  def jira_issue
    matches = title.match(/[A-Z]+-[0-9]+/)
    return "" if matches.nil?
    matches[0]
  end

  def app_log
    return "" unless !!repo.log_file
    ensure_builds_dir_exists
    file = File.join(build_path, repo.log_file) 
    return "" if !File.exists?(file)
    open(file).read 
  end

  def build_log
    ensure_builds_dir_exists
    file = File.join(build_path, 'build.log') 
    return "" if !File.exists?(file)
    open(file).read 
  end

  # Update the status immediately to 'in queue', but Delayed Job the build
  def delayed_build
    update_attributes(status: 3)
    self.delay.build
  end

  def build
    update_attributes(status: 0) # set to 'building'

    ensure_builds_dir_exists

    checkout

    provision_resources

    run_build_command

    update_attributes(status: 1) # set to 'complete'
  rescue
    update_attributes(status: 2) # set to 'failed'
    Rails.logger.error $!.to_s
    raise $!
  end

  def checkout
    ensure_builds_dir_exists

    if !Dir.exists?(build_path)
      FileUtils.cp_r(repo.cached_copy, build_path)
    end

    system("cd #{build_path} && git fetch origin && git checkout #{head_ref} && git reset --hard origin/#{head_ref}")
      raise "Error checking out ref" if $? != 0
  end

  def provision_resources
    if repo.should_provision_mysql
      provisioned_mysql.destroy if !!provisioned_mysql
      update_attributes(provisioned_mysql: ProvisionedMysql.create(self))
    end

    if repo.should_provision_nginx
      provisioned_nginx.destroy if !!provisioned_nginx
      update_attributes(provisioned_nginx: ProvisionedNginx.create(self))
    end

    if repo.should_provision_redis
      provisioned_redis.destroy if !!provisioned_redis
      update_attributes(provisioned_redis: ProvisionedRedis.create(self))
    end
  end

  def run_build_command
    env_vars = {}
    if !!provisioned_mysql
      env_vars.merge!(
        "MYSQL_DB" => provisioned_mysql.db,
        "MYSQL_USER" => provisioned_mysql.user,
        "MYSQL_PASSWORD" => provisioned_mysql.password,
      )
    end

    if !!provisioned_redis
      env_vars.merge!("REDIS_PORT" => provisioned_redis.port)
    end
    
    env_vars = env_vars.map { |env,val| "CHRYSALIS_#{env}=#{val}" }.join(" ")

    Rails.logger.info "Building #{build_path}"
    system("cd #{build_path} && #{env_vars} ./build/build.sh 2>&1 > build.log")
    raise "Error running build.sh" if 0 != $?
  end

  def destroy_build
    if Dir.exists?(build_path.to_s)
      FileUtils.remove_dir(build_path.to_s)
    end
  end

  def build_path
    return nil unless !!repo
    builds_dir = Rails.root.join('builds')
    builds_dir.join("#{repo.owner}-#{repo.name}-#{number}")
  end

  def website
    if !!repo.nginx_template && repo.should_provision_nginx
      match = repo.nginx_template.match(/server_name (.*);/)
      return !!match[1] ? match[1].gsub('{{number}}', number.to_s) : nil
    end
    nil
  end

  private

  def ensure_builds_dir_exists
    builds_dir = Rails.root.join('builds')
    FileUtils.mkdir_p(builds_dir)
  end

end
