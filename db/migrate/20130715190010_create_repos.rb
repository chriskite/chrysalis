class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :owner
      t.string :token

      t.timestamps
    end
  end
end
