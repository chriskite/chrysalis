class CreateProvisionedNginxes < ActiveRecord::Migration
  def change
    create_table :provisioned_nginxes do |t|
      t.string :sites_available_file
      t.string :sites_enabled_file
      t.references :pull_request, index: true

      t.timestamps
    end
  end
end
