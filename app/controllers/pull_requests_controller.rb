class PullRequestsController < ApplicationController
  # GET /pull_requests/1
  # GET /pull_requests/1.json
  def show
    @pull_request = PullRequest.find(params[:id])

    respond_to do |format|
      format.json { render json: @pull_request }
    end
  end
end
