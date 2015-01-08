class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    current_token = SessionToken.find_by(session_token: session[:session_token])
    current_token ? current_token.user : nil
  end

  def log_in! user
    new_token = SessionToken.create(user_id: user.id, browser_info: get_browser, ip_address: get_ip_address)
    session[:session_token] = new_token.session_token
  end

  def log_out! user
    SessionToken.find_by(session_token: session[:session_token]).destroy
    session[:session_token] = nil
  end

  def log_out_other_device! token
    SessionToken.find_by(session_token: token).destroy
  end

  def already_logged_in?
    if current_user
      flash[:error] = "You are already logged in"
      redirect_to cats_url
    end
  end

  def require_login
    unless current_user
      flash[:error] = "You're not logged in"
      redirect_to new_session_url
    end
  end

  def get_browser
    browser = Browser.new(ua: request.env["HTTP_USER_AGENT"], accepted_language: "en-us")
    "#{browser.platform.to_s.capitalize}: #{browser.name}"
  end

  def get_ip_address
    request.remote_ip.to_sym
  end
end
