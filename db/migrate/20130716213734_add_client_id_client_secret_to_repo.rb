class AddClientIdClientSecretToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :client_id, :string
    add_column :repos, :client_secret, :string
  end
end
