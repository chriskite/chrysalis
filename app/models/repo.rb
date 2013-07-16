class Repo < ActiveRecord::Base
  has_many :pull_requests
  attr_accessible :name, :owner, :token

  def self.sync_all_with_github
    all.each do |repo|
      begin
        # Connect to GitHub with the repo's credentials
        github = Github.new do |config|
          config.user = repo.owner
          config.repo = repo.name
          config.oauth_token = repo.token
        end

        # for each github pull request

          # if this repo already has it
            # delete if state == 'closed'
          # else
            # create if state == 'open'
        # set repo.github_status = 1
      rescue
        # Set the error status
        repo.update(github_status: 2)
      end

      # Set the success status
      repo.update(github_status: 1)
    end
  end
end
