class ProvisionedMysql < ActiveRecord::Base
  belongs_to :pull_request

  before_destroy :destroy_mysql

  attr_accessible :db, :host, :password, :user, :pull_request

  def self.mysql_client
    Mysql2::Client.new(
      host: Rails.configuration.mysql_host,
      username: Rails.configuration.mysql_user,
      password: Rails.configuration.mysql_password,
    )

  end

  def self.create(pull_request)
    repo = pull_request.repo
    db = "chrysalis_#{repo.owner}_#{repo.name}_#{pull_request.number.to_s}"
    
    client = self.mysql_client

    client.query <<END
CREATE DATABASE IF NOT EXISTS #{client.escape(db)}
  DEFAULT CHARACTER SET = 'utf8'
  DEFAULT COLLATE = 'utf8_general_ci'
END

    self.new(
      db: db,
      host: Rails.configuration.mysql_host,
      user: Rails.configuration.mysql_user,
      password: Rails.configuration.mysql_password,
      pull_request: pull_request
    )
  end

  def destroy_mysql
    client = self.class.mysql_client
    client.query("DROP DATABASE IF EXISTS #{client.escape(db)}")
  end

end
