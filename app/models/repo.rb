class Repo < ActiveRecord::Base
  has_many :pull_requests
  attr_accessible :name, :owner, :token, :client_id, :client_secret, :github_status, :jira_url

  def self.sync_all_with_github
    all.each do |repo|
      begin
        github = Github.new(oauth_token: repo.token)

        # Get all open pull requests for this repo
        open_pulls = github.pull_requests.list(repo.owner, repo.name)
        open_pulls.each do |pull|
          # Check if this pull request is already in the db
          existing_pull = repo.pull_requests.where(number: pull.number).first

          # If it's new, save to the db
          if existing_pull.nil?
            new_pull = PullRequest.new
            new_pull.repo = repo
            new_pull.number = pull.number
            new_pull.url = pull.html_url
            new_pull.title = pull.title
            new_pull.user_login = pull.user.login
            new_pull.user_avatar_url = pull.user.avatar_url
            new_pull.github_created_at = pull.created_at
            new_pull.github_updated_at = pull.updated_at
            new_pull.save
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

end
