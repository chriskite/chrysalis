class AddLogFileToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :log_file, :string
  end
end
