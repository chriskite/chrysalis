class AddGithubApiFieldsToPullRequest < ActiveRecord::Migration
  def change
      rename_column :pull_requests, :github_id, :number
      rename_column :pull_requests, :branch, :title
      add_column :pull_requests, :url, :string
      add_column :pull_requests, :user_login, :string
      add_column :pull_requests, :user_avatar_url, :string
  end
end
