class StoriesController < ApplicationController
  before_action :validate_params, only: [:create]

  def create
    id = Story.create(story_params[:url])
    if id
      render json: {id: id}
    else
      render json: {status: "error", message: "Something went wrong"}, status: 500
    end
  end
  
  def show
    data = Story.find(params[:id])
    if data
      render json: data
    else
      render json: { status: "error", message: 'Resource not found'}, status: 404 
    end
  end

  private

  def validate_params
    render json: { status: "error", message: "'url' is missing"}, status: 400 unless params[:url]
  end

  def story_params
    params.permit(:url)
  end
end