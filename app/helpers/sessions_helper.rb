module SessionsHelper

    #Logs in the given user
    def logs_in(user)
      session[:user_id] = user.id
    end
    
    # Returns the current logged-in user (if any).

    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end

    def logged_in?
      !current_user.nil?
    end

    #logs out the current user
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end

    # Returns true if the given user is the current user.
    def current_user?(user)
      user && user == current_user
    end

    #redirects to stored location (or to the default)
    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end

    # stores the URL trying to be accessed
    def store_location
      session[:forwarding_url] = request.original_url if request.get?
    end

    # returns the current logged-in user(if any)
    def current_user
      if(user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end
end
