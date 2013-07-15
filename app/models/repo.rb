class Repo < ActiveRecord::Base
  attr_accessible :name, :owner, :token
end
