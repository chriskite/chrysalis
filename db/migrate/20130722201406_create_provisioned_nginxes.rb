class CreateProvisionedNginxes < ActiveRecord::Migration
  def change
    change_table :pull_requests do |t|
      t.references :provisioned_nginx, index: true
    end

    create_table :provisioned_nginxes do |t|
      t.string :sites_available_file
      t.string :sites_enabled_file

      t.timestamps
    end
  end
end
