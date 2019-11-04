class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if(user && user.authenticate(params[:session][:password]))
      #login and redirect to user's show page
      if user.activated?
        log_in user
        # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      end
    else
      message = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_url
    end

  end

  def destroy
    log_out
    redirect_to root_url
  end

end


