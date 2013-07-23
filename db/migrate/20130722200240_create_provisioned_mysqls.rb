class CreateProvisionedMysqls < ActiveRecord::Migration
  def change
    create_table :provisioned_mysqls do |t|
      t.string :db
      t.string :user
      t.string :password
      t.string :host
      t.references :pull_request, index: true

      t.timestamps
    end
  end
end
