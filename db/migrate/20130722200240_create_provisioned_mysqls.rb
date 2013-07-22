class CreateProvisionedMysqls < ActiveRecord::Migration
  def change
    create_table :provisioned_mysqls do |t|
      t.references :pull_request
      t.string :db
      t.string :user
      t.string :password
      t.string :host

      t.timestamps
    end
    add_index :provisioned_mysqls, :pull_request_id
  end
end
