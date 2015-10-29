class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:login]
  before_action :load_user, except: [:index, :login]

  def login
    github_token = request.headers['HTTP_X_GITHUB_TOKEN']
    user = User.login!(github_token)

    respond_to do |format|
      format.json { render json: {"login" => user.name, "token" => user.token}}
    end
  end

  def show
    render json: current_user
  end

  def update
    current_user.update(update_params)
    render json: current_user
  end

  private

  def load_user
    @user = if params[:id].present?
              User.find_by!(name: params[:id])
            else
              current_user
            end
    authorize @user
  end

  def update_params
    params.permit [
      :public_key
    ]
  end
end
