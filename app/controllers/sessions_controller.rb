class SessionsController < ApplicationController
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

    def create
        @user = User.find_by(username: session_params[:username])
      
        if @user && @user.authenticate(session_params[:password])
          login!
          render json: {
            logged_in: true,
            user: @user
          }
        else
          render json: { 
            status: 401,
            errors: ['no such user', 'verify credentials and try again or signup']
          }
        end
    end

    def is_logged_in?
        if logged_in? && current_user
          render json: {
            logged_in: true,
            user: current_user
          }
        else
          render json: {
            logged_in: false,
            message: 'no such user'
          }
        end
      end
    def destroy
        logout!
        render json: {
          status: 200,
          logged_out: true
        }
      end
    private
    def session_params
        params.require(:user).permit(:username, :email, :password)
      end
    end