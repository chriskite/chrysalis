class AddRedisOptionToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :should_provision_redis, :boolean
  end
end
