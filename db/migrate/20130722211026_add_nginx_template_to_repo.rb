class AddNginxTemplateToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :nginx_template, :text
  end
end
