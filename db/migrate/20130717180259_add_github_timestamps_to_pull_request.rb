class AddGithubTimestampsToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :github_created_at, :timestamp
    add_column :pull_requests, :github_updated_at, :timestamp
  end
end
