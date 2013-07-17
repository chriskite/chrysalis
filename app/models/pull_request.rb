class PullRequest < ActiveRecord::Base
  belongs_to :repo
  has_many :builds
  attr_accessible :author,
                  :branch,
                  :github_updated_at,
                  :status

  def build
    update_attributes(status: 0)
    begin
      builds_dir = Rails.root.join('builds')
      system("mkdir -p #{builds_dir}")
      raise "Error creating builds dir" if $? != 0

      @build_path = builds_dir.join("#{repo.owner}.#{repo.name}.#{number}")

      checkout

      build_mysql if repo.should_build_mysql
      build_nginx if repo.should_build_nginx

      # TODO run build command
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

  def build_mysql
    raise "should_build_mysql option is set to false" unless should_build_mysql
    # return if db already exists for this pull request
  end

  def build_nginx
    raise "should_build_nginx option is set to false" unless should_build_nginx
  end
end
