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

  def build
    update_attributes(status: 0)
    begin
      ensure_builds_dir_exists

      checkout

      provision_resources

      run_build_command
    rescue
      update_attributes(status: 2)
      raise $!
    end

    update_attributes(status: 1)
  end
  #handle_asynchronously :build

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
