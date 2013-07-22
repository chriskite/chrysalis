class CreateProvisionedMysqls < ActiveRecord::Migration
  def change
    change_table :pull_requests do |t|
      t.references :provisioned_mysql, index: true
    end

    create_table :provisioned_mysqls do |t|
      t.string :db
      t.string :user
      t.string :password
      t.string :host

      t.timestamps
    end
  end
end
