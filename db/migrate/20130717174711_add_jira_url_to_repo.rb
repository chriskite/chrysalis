class AddJiraUrlToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :jira_url, :string
  end
end
