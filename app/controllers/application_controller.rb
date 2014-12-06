class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    def authenticate_user_from_token!
      if token = params[:auth_token].presence
        if user = User.find_by(auth_token: token)
          sign_in(user, store: false)
        end
      end
    end
    
end
