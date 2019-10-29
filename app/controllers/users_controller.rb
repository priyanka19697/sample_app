class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])  
  end

  def index 
    @users = User.all
  end


  def new
    @user = User.new
  end
  
  def create
    # @user = User.new(params[:user])
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      #handle a successful save
      redirect_to user_url @user
    else 
      render 'new'
    end

  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
  