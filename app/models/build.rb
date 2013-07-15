class Build < ActiveRecord::Base
  belongs_to :pull_request
  attr_accessible :status
end
