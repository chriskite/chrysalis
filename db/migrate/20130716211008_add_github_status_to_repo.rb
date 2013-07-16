class AddGithubStatusToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :github_status, :integer
  end
end
