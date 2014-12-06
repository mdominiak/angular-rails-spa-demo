module Api
  class BaseController < ApplicationController
    skip_before_filter :verify_authenticity_token
    rescue_from 'ActiveRecord::RecordNotFound' do
      head status: :not_found
    end
  end
end