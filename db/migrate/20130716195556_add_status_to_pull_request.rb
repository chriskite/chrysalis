class AddStatusToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :status, :integer
  end
end
