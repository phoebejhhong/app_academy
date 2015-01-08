class SessionsController < ApplicationController
  before_action :already_logged_in?, only: [:new, :create]
  before_action :require_login, except: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password],
      )
    if user.nil?
      @user = User.new(username: params[:user][:username])
      flash[:errors] = ["Invalid password, or username"]
      render :new
    else
      log_in!(user)
      redirect_to cats_url
    end
  end

  def destroy
    log_out!(current_user)
    redirect_to new_session_url
  end

  def log_out_other_device
    @token = params[:token][:session_token]
    log_out_other_device! @token
    redirect_to user_url
  end
end
