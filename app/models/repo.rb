class Repo < ActiveRecord::Base
  has_many :pull_requests, dependent: :destroy, order: "github_updated_at ASC"

  validates_presence_of :name, :owner

  attr_accessible :name,
                  :owner,
                  :token,
                  :client_id,
                  :client_secret,
                  :github_status,
                  :jira_url,
                  :should_provision_mysql,
                  :should_provision_nginx,
                  :should_provision_redis,
                  :nginx_template,
                  :redis_template,
                  :log_file,
                  :jira_username,
                  :jira_password

  def self.sync_all_with_jira
    all.each do |repo|
      next unless !!repo.jira_url # skip if this repo isn't configured for jira

      client = repo.jira_client
      repo.pull_requests.each do |pull_request|
        begin
          pull_request.sync_with_jira(client)
        rescue
          Rails.logger.warn($!.to_s)
        end
      end
    end
  end

  def self.sync_all_with_github
    all.each do |repo|
      begin
        repo.clone_into_cached_copy

        github = Github.new(oauth_token: repo.token)

        # Get first 100 open pull requests for this repo
        open_pulls = github.pull_requests.list(repo.owner, repo.name, per_page: 100)
        open_pulls.each do |pull|
          # Check if this pull request is already in the db
          existing_pull = repo.pull_requests.where(number: pull.number).first

          # If it's new, save to the db
          if existing_pull.nil?
            new_pull = repo.new_pull_from_api(pull)
            new_pull.delayed_build

            if !!repo.jira_url
              # Comment on the jira issue
              client = repo.jira_client
              new_pull.comment_on_jira_issue(client)
            end
          else
            # If the remote pull request has been updated, save and check back out
            if DateTime.parse(pull.updated_at) > existing_pull.updated_at
              existing_pull.update_attributes(
                title: pull.title,
                github_updated_at: pull.updated_at
              )
              existing_pull.checkout

              # if it was failed, rebuild with the updated code
              existing_pull.delayed_build if 2 == existing_pull.status
            end
          end
        end

        # Delete any previously saved pull requests that are no longer open
        open_pull_numbers = open_pulls.map(&:number)
        repo.pull_requests.each { |pr| pr.destroy if !open_pull_numbers.include?(pr.number) }
      rescue
        # Set the error status
        repo.update_attributes(github_status: 2)
        raise $!
      end

      # Set the success status
      repo.update_attributes(github_status: 1)
    end
  end

  def jira_client
    options = {
                :username => jira_username,
                :password => jira_password,
                :use_ssl => false,
                :context_path => '/',
                :site     => jira_url,
                :auth_type => :basic
              }

    JIRA::Client.new(options)
  end

  def clone_url
    "git@github.com:#{owner}/#{name}.git"
  end

  def clone_into_cached_copy
    system("git clone #{clone_url} #{cached_copy}") if !Dir.exists?(cached_copy)
  end

  def new_pull_from_api(pull)
    new_pull = PullRequest.new
    new_pull.repo = self
    new_pull.number = pull.number
    new_pull.url = pull.html_url
    new_pull.title = pull.title
    new_pull.user_login = pull.user.login
    new_pull.user_avatar_url = pull.user.avatar_url
    new_pull.github_created_at = pull.created_at
    new_pull.github_updated_at = pull.updated_at
    new_pull.head_ref = pull.head.ref
    new_pull.head_sha = pull.head.sha
    new_pull.status = 3 # not started
    new_pull.save
    new_pull
  end

  def cached_copy
    Rails.root.join("builds", "#{owner}-#{name}-cached-copy")
  end

end
