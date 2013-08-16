class AddJiraFieldsToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :jira_username, :string
    add_column :repos, :jira_password, :string
  end
end
