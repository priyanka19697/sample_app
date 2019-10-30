class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if(user && user.authenticate(params[:session][:password]))
      #login and redirect to user's show page
      log_in(user)
      # redirect_to user
      redirect_back_or user
    else
      #create an error message - contents of flash.now disappear as soon as there is an additional request
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end

  end

  def destroy
    log_out
    redirect_to root_url
  end

end
