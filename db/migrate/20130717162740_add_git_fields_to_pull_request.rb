class AddGitFieldsToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :head_ref, :string
    add_column :pull_requests, :head_sha, :string
    add_column :pull_requests, :clone_url, :string
  end
end
