class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.references :pull_request
      t.integer :status

      t.timestamps
    end
    add_index :builds, :pull_request_id
  end
end
