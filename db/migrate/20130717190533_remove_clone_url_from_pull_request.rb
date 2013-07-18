class RemoveCloneUrlFromPullRequest < ActiveRecord::Migration
  def change
    remove_column :pull_requests, :clone_url
  end
end
