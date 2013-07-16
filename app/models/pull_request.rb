class PullRequest < ActiveRecord::Base
  belongs_to :repo
  has_many :builds
  attr_accessible :author, :branch
end
