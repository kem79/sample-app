module SessionsHelper
  
  # Login the given user
  # create a cookie which is encrypted and last until browser is closed
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies.signed[:remember_token])
        log_in user
        @current_user = user
      end
    end
    
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end
  
end
