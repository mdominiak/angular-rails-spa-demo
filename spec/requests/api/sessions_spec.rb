require 'rails_helper'

describe "Sessions API", type: :request do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'login' do
    it 'success' do
      post "/api/users/sign_in", user: { email: user.email, password: user.password }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to eq({'email' => user.email, 'daily_calories' => 2000})
    end

    it 'with invalid credentials' do
      post "/api/users/sign_in", email: user.email, password: 'invalid'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'logout' do
    before do
      post "/api/users/sign_in", user: { email: user.email, password: user.password }
    end

    it 'success' do
      delete "/api/users/sign_out"
      expect(response).to have_http_status(204)
      expect(response.body).to be_empty
    end
  end

end