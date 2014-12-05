module Api
  class BaseController < ApplicationController
    rescue_from 'ActiveRecord::RecordNotFound' do
      head status: :not_found
    end
  end
end