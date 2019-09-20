class ActiveApisController < ApplicationController
  before_action :authorize_access_request!
  def index
    @apis = current_user.active_apis

    render json: @apis
  end

  def create
    @api = current_user.active_apis.build(api_params)

    if @api.save
        render json: @api, status: :created, location: @api
    else
        render json: @api.errors, status: :unprocessable_entity
    end
  end 

  def destroy
    @api = current_user.apis.find(params[:id])
    @api.destroy
  end

  private

  def api_params
    params.require(:active_api).permit(:name,:api_url,:api_key)
  end 
end
