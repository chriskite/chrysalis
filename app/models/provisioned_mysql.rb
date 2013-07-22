class ProvisionedMysql < ActiveRecord::Base
  belongs_to :pull_request
  attr_accessible :db, :host, :password, :user
end
