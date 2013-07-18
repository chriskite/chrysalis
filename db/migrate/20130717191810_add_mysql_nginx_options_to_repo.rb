class AddMysqlNginxOptionsToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :should_build_mysql, :bool
    add_column :repos, :should_build_nginx, :bool
  end
end
