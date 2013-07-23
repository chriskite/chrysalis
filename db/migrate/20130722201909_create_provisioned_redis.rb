class CreateProvisionedRedis < ActiveRecord::Migration
  def change
    create_table :provisioned_redis do |t|
      t.integer :port
      t.string :pidfile
      t.string :config_file
      t.references :pull_request, index: true

      t.timestamps
    end
  end
end
