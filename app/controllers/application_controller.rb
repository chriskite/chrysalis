class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    @repos = Repo.all
  end

end
