class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id]) 
    @microposts = @user.microposts.paginate(page: params[:page]) 
  end

  # def setup
  #   @user = users(:michael)
  #   @other_user = users(:archer)
  # end

  def index 
    @users = User.all
    # @users = User.where(activated: true)paginate(page: params[:page])
  end

  def new
    @user = User.new
  end
  
  def create
    # @user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # #handle a successful save
      # redirect_to user_url @user
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else 
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #handle a successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  # # confirms logged in user
  # def logged_in_user
  #   unless logged_in?
  #     flash[:danger] = "Please log in"
  #     redirect_to login_url
  #   end
  # end

  #confirms correct user to edit
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # admin is not in the list of permitted attributes.
  end

end

# User.last.send(:activate)
  