class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    helper_method :login!, :logged_in?, :current_user, :authorized_user?, :logout!
    before_filter :cors_preflight_check
    after_filter :cors_set_access_control_headers
    
    # For all responses in this controller, return the CORS access control headers.
    
    def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token}.join(',')
        headers['Access-Control-Max-Age'] = "1728000"
    end
    
    def cors_preflight_check
      if request.method == "OPTIONS"
        headers['Access-Control-Allow-Origin'] = 'http://localhost'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token}.join(',')
        headers['Access-Control-Max-Age'] = '1728000'
        render :text => '', :content_type => 'text/plain'
      end
    end
  
    def login!
      session[:user_id] = @user.id
    end
  def logged_in?
      !!session[:user_id]
    end
  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  def authorized_user?
       @user == current_user
     end
  def logout!
       session.clear
     end
  end