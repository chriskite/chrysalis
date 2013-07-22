class ReposController < ApplicationController
  # GET /repos
  # GET /repos.json
  def index
    @repos = Repo.all

    respond_to do |format|
      format.json { render json: @repos.to_json(include: :pull_requests) }
    end
  end

  # GET /repos/1
  # GET /repos/1.json
  def show
    @repo = Repo.find(params[:id])

    respond_to do |format|
      format.json { render json: @repo }
    end
  end

  # GET /repos/new
  # GET /repos/new.json
  def new
    @repo = Repo.new

    respond_to do |format|
      format.json { render json: @repo }
    end
  end

  # GET /repos/1/edit
  def edit
    @repo = Repo.find(params[:id])
  end

  # POST /repos
  # POST /repos.json
  def create
    params[:repo].delete(:pull_requests)
    @repo = Repo.new(params[:repo])

    respond_to do |format|
      if @repo.save
        format.json { render json: @repo, status: :created, location: @repo }
      else
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /repos/1
  # PUT /repos/1.json
  def update
    blacklist = [:pull_requests, :created_at, :updated_at]
    blacklist.each { |field| params[:repo].delete(field) }

    @repo = Repo.find(params[:id])

    respond_to do |format|
      if @repo.update_attributes(params[:repo])
        format.json { head :no_content }
      else
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repos/1
  # DELETE /repos/1.json
  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
