class PullRequest < ActiveRecord::Base
  belongs_to :repo
  attr_accessible :author, :branch
end
