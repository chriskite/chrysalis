class ProvisionedRedis < ActiveRecord::Base
  belongs_to :pull_request
  attr_accessible :config_file, :pidfile, :port
end
