class RenameRepoOptions < ActiveRecord::Migration
  def change
    rename_column :repos, :should_build_mysql, :should_provision_mysql
    rename_column :repos, :should_build_nginx, :should_provision_nginx
  end
end
