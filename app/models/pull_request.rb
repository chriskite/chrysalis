class PullRequest < ActiveRecord::Base
  belongs_to :repo
  has_one :provisioned_mysql, dependent: :destroy
  has_one :provisioned_nginx, dependent: :destroy
  has_one :provisioned_redis, dependent: :destroy

  attr_reader :build_path

  before_destroy :destroy_build

  attr_accessible :author,
                  :branch,
                  :github_updated_at,
                  :status,
                  :provisioned_mysql,
                  :provisioned_nginx,
                  :provisioned_redis

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

    if !Dir.exists?(@build_path)
      FileUtils.cp_r(repo.cached_copy, @build_path)
    end

    system("cd #{@build_path} && git fetch origin && git checkout #{head_ref} && git reset --hard origin/#{head_ref}")
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

    Rails.logger.info "Building #{@build_path}"
    system("cd #{@build_path} && #{env_vars} ./build/build.sh")
    raise "Error running build.sh" if 0 != $?
  end

  def destroy_build
    if Dir.exists?(@build_path.to_s)
      FileUtils.rmdir(@build_path.to_s)
    end
  end

  private

  def ensure_builds_dir_exists
    builds_dir = Rails.root.join('builds')
    FileUtils.mkdir_p(builds_dir)
    @build_path = builds_dir.join("#{repo.owner}-#{repo.name}-#{number}")
  end

end
