class Repo < ActiveRecord::Base
  has_many :pull_requests
  attr_accessible :name, :owner, :token
end
