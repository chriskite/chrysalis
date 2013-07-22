class AddRedisTemplateToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :redis_template, :text
  end
end
