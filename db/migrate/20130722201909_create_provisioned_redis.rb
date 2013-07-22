class CreateProvisionedRedis < ActiveRecord::Migration
  def change
    change_table :pull_requests do |t|
      t.references :provisioned_redis, index: true
    end

    create_table :provisioned_redis do |t|
      t.integer :port
      t.string :pidfile
      t.string :config_file

      t.timestamps
    end
  end
end
