class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.references :repo
      t.string :branch
      t.string :author

      t.timestamps
    end
    add_index :pull_requests, :repo_id
  end
end
