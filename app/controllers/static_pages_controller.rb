class StaticPagesController < ApplicationController
  include SessionsHelper

  def home
   if logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page])
   end
  end

  def help
  end

  def about
  end

  def contact
  end

end

# ["created_at", "2019-11-04 05:26:58.070045"], ["updated_at", "2019-11-04 05:26:58.070045"],
#  ["password_digest", "$2a$12$MdxE0bg1jYMZwkuDITjS/u.qvEsGmaMioZyBRKTzn8S3JC5HbidT."],
#  ["activation_digest", "$2a$12$Z8rOxfAXhozmLuGarO0YT.0AUo3a7uWzk8aFIWJ1cmT7BW06e1ycG"]]
