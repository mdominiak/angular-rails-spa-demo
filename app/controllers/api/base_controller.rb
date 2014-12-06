module Api
  class BaseController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_filter :authenticate_user_from_token!
    before_filter :authenticate_user!

    rescue_from 'ActiveRecord::RecordNotFound' do
      head status: :not_found
    end
  end
end