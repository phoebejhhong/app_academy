class UsersController < ApplicationController
  before_action :already_logged_in?, only: [:new, :create]
  before_action :require_login, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in!(@user)
      redirect_to cats_url
    else
      flash[:notice] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_url
    else
      flash[:notice] = @user.errors.full_messages
      render :edit
    end
  end

  def show
    @user = current_user
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
