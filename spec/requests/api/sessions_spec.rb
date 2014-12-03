require 'rails_helper'

describe "Sessions API", type: :request do
  let!(:user) { FactoryGirl.create(:user) }

  it 'successful authentication' do
    post "/api/users/sign_in.json", user: { email: user.email, password: user.password }
    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json).to eq({'email' => user.email})
  end

  it 'authentication with invalid credentials' do
    post "/api/users/sign_in.json", email: user.email, password: 'invalid'
    expect(response).to have_http_status(:unauthorized)
  end

end
