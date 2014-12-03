module Api
  class SessionsController < Devise::SessionsController
    skip_before_filter :verify_authenticity_token
    respond_to :json

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      render status: :created
    end
    
  end
end