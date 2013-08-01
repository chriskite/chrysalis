class PullRequestsController < ApplicationController
  # GET /pull_requests/1
  # GET /pull_requests/1.json
  def show
    @pull_request = PullRequest.find(params[:id])

    respond_to do |format|
      format.json { render json: @pull_request }
    end
  end

  def rebuild
    @pull_request = PullRequest.find(params[:id])

    @pull_request.delayed_build

    respond_to do |format|
      format.json { render json: { status: @pull_request.status }.to_json }
    end
  end

  def build_log
    @pull_request = PullRequest.find(params[:id])

    respond_to do |format|
      format.json { render json: { build_log: @pull_request.build_log }.to_json }
      format.html { render text: @pull_request.build_log }
    end
  end

  def app_log
    @pull_request = PullRequest.find(params[:id])

    respond_to do |format|
      format.json { render json: { app_log: @pull_request.app_log }.to_json }
      format.html { render text: @pull_request.app_log }
    end
  end
end
