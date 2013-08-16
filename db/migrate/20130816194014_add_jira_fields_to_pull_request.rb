class AddJiraFieldsToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :jira_status_name, :string
    add_column :pull_requests, :jira_status_icon_url, :string
  end
end
