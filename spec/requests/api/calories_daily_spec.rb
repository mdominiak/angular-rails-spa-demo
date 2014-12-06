require 'rails_helper'

describe 'Calories Daily API' do

  context 'authenticated' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      post "/api/users/sign_in", user: { email: user.email, password: user.password }
    end

    describe 'index' do
      let!(:meals) do
        user.meals.create([
          {calories: 300, eaten_at: "2014-12-06 12:00"},
          {calories: 200, eaten_at: "2014-12-06 13:00"},
          {calories: 3000, eaten_at: "2014-12-05 10:00"}
        ])
      end

      it 'success' do
        get '/api/calories_daily'
        expect(response).to have_http_status(200)
        arr = JSON.parse(response.body)
        expected = [
          {'date' => '2014-12-06'.as_json, 'calories' => 500},
          {'date' => '2014-12-05'.as_json, 'calories' => 3000}
        ]
        expect(arr).to eq expected
      end

      it 'with date from filter' do
        get '/api/calories_daily', date_from: '2014-12-06'
        expect(response).to have_http_status(200)
        arr = JSON.parse(response.body)
        expected = [
          {'date' => '2014-12-06'.as_json, 'calories' => 500}
        ]
        expect(arr).to eq expected        
      end

      it 'with date to filter' do
        get '/api/calories_daily', date_to: '2014-12-05'
        expect(response).to have_http_status(200)
        arr = JSON.parse(response.body)
        expected = [
          {'date' => '2014-12-05'.as_json, 'calories' => 3000}
        ]
        expect(arr).to eq expected        
      end

      it 'with time from filter' do
        get '/api/calories_daily', time_from: '13:00'
        expect(response).to have_http_status(200)
        arr = JSON.parse(response.body)
        expected = [
          {'date' => '2014-12-06'.as_json, 'calories' => 200}
        ]
        expect(arr).to eq expected        
      end

      it 'with time to filter' do
        get '/api/calories_daily', time_to: '10:00'
        expect(response).to have_http_status(200)
        arr = JSON.parse(response.body)
        expected = [
          {'date' => '2014-12-05'.as_json, 'calories' => 3000}
        ]
        expect(arr).to eq expected        
      end
    end
  end

  context 'unauthenticated' do
    it 'index' do
      get '/api/calories_daily'
      expect(response).to have_http_status(401)
    end
  end
end