class PullRequest < ActiveRecord::Base
  belongs_to :repo
  has_many :builds
  has_one :provisioned_mysql
  has_one :provisioned_nginx
  has_one :provisioned_redis

  attr_accessible :author,
                  :branch,
                  :github_updated_at,
                  :status,
                  :build_path

  def build
    update_attributes(status: 0)
    begin
      builds_dir = Rails.root.join('builds')
      FileUtils.mkdir_p(builds_dir)

      @build_path = builds_dir.join("#{repo.owner}.#{repo.name}.#{number}")

      checkout

      provision_resources

      run_build_command
    rescue
      update_attributes(status: 2)
    end

    update_attributes(status: 1)
  end
  #handle_asynchronously :build

  def checkout
    if !Dir.exists?(@build_path)
      system("git clone #{repo.clone_url} #{@build_path}")
      raise "Error cloning repo" if $? != 0
    end
    system("cd #{@build_path} && git fetch origin && git checkout #{head_ref} && git pull origin #{head_ref}")
      raise "Error checking out ref" if $? != 0
  end

  def provision_resources
    if repo.should_provision_mysql
      update_attributes(provisioned_mysql: ProvisionedMysql.create(self))
    end

    if repo.should_provision_nginx
      update_attributes(provisioned_nginx: ProvisionedNginx.create(self))
    end

    if repo.should_provision_redis
      update_attributes(provisioned_redis: ProvisionedRedis.create(self))
    end
  end

  def run_build_command
    # TODO run build command
  end
end
