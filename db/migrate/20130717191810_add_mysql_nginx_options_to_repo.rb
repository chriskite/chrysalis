class AddMysqlNginxOptionsToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :should_build_mysql, :boolean
    add_column :repos, :should_build_nginx, :boolean
  end
end
