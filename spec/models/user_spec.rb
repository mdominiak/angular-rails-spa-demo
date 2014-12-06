require 'rails_helper'

describe User, type: :model do
  describe 'create' do
    it 'should have auth token' do
      user = FactoryGirl.create(:user)
      expect(user.auth_token).to be_present
    end
  end
end