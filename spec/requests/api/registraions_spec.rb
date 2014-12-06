require 'rails_helper'

describe 'Registrations API', type: :request do

  describe 'sign up' do
    let(:user_attr) { FactoryGirl.attributes_for(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    it 'success' do
      post '/api/users', user: { email: user_attr[:email], password: user_attr[:password] }
      expect(response).to have_http_status(201)

      json = JSON.parse(response.body)
      expect(json).to eq({'email' => user_attr[:email]})

      user = User.last
      expect(user.email).to eq user_attr[:email]
      expect(user.encrypted_password).to be_present
    end

    it 'with invalid attributes' do
      post '/api/users'
      expect(response).to have_http_status(422)
      errors = JSON.parse(response.body)['errors']
      expect(errors.length).to eq 2
      expect(errors).to include "Email can't be blank"
      expect(errors).to include "Password can't be blank"
    end

    it 'with taken email' do
      post '/api/users', user: {email: other_user.email, password: other_user.password}
      expect(response).to have_http_status(422)
      errors = JSON.parse(response.body)['errors']
      expect(errors).to eq ["Email has already been taken"]
    end
  end

end