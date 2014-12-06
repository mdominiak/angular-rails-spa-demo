require 'rails_helper'

describe 'Meals API', type: :request do

  context 'authenticated' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:meals) do
      user.meals.create([
        FactoryGirl.attributes_for(:meal, eaten_at: "2014-12-05 10:00"),
        FactoryGirl.attributes_for(:meal, eaten_at: "2014-12-06 11:00")
      ])
    end
    let(:meal) { meals.first }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:other_meal) { other_user.meals.create FactoryGirl.attributes_for(:meal) }

    before do
      post "/api/users/sign_in", user: { email: user.email, password: user.password }
    end

    describe 'index' do
      it 'success' do
        get '/api/meals'
        expect(response).to have_http_status(200)

        json_arr = JSON.parse(response.body)
        expect(json_arr.length).to eq 2

        expect(json_arr.map{|m| m['id']}).to eq meals.map(&:id).reverse

        json_meal = json_arr.first
        meal = meals.last
        expect(json_meal.keys.sort).to eq %w{id eaten_at calories description}.sort
        expect(json_meal['id']).to eq meal.id
        expect(json_meal['calories']).to eq meal.calories
        expect(json_meal['description']).to eq meal.description
        expect(json_meal['eaten_at']).to eq meal.eaten_at.as_json
      end

      it 'with date from filter' do
        get '/api/meals', date_from: "2014-12-06"
        expect(response).to have_http_status(200)
        json_arr = JSON.parse(response.body)
        expect(json_arr.length).to eq 1
      end

      it 'with date to filter' do
        get '/api/meals', date_to: "2014-12-05"
        expect(response).to have_http_status(200)
        json_arr = JSON.parse(response.body)
        expect(json_arr.length).to eq 1
      end

      it 'with time from filter' do
        get '/api/meals', time_from: "11:00"
        expect(response).to have_http_status(200)
        json_arr = JSON.parse(response.body)
        expect(json_arr.length).to eq 1
      end

      it 'with time from filter' do
        get '/api/meals', time_to: "10:00"
        expect(response).to have_http_status(200)
        json_arr = JSON.parse(response.body)
        expect(json_arr.length).to eq 1
      end
    end

    describe 'create' do
      let(:meal_attr) {
        {
          eaten_at: Time.now.utc.as_json,
          description: 'description',
          calories: 500
        }
      }

      it 'success' do
        post '/api/meals', meal: meal_attr
        expect(response).to have_http_status(201)

        expect(user.meals.count).to eq 3
        meal = user.meals.last
        expect(meal.calories).to eq meal_attr[:calories]
        expect(meal.description).to eq meal_attr[:description]
        expect(meal.eaten_at.as_json).to eq meal_attr[:eaten_at].as_json

        json = JSON.parse(response.body)
        expect(json.keys.sort).to eq %w{id calories eaten_at description}.sort
        expect(json['id']).to eq meal.id
        expect(json['calories']).to eq meal.calories
        expect(json['description']).to eq meal.description
        expect(json['eaten_at']).to eq meal.eaten_at.as_json
      end

      it 'with invalid params' do
        post '/api/meals', meal: {calories: ''}
        expect(response).to have_http_status(422)
      end
    end

    describe 'destroy' do
      it 'success' do
        delete "/api/meals/#{meal.id}"
        expect(response).to have_http_status(204)
        expect(user.meals.count).to eq 1
      end

      it 'not found' do
        delete "/api/meals/0"
        expect(response).to have_http_status(404)
      end

      it 'access denied' do
        delete "/api/meals/#{other_meal.id}"
        expect(response).to have_http_status(404)
      end
    end

    describe 'show' do
      it 'success' do
        get "/api/meals/#{meal.id}"
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['id']).to eq meal.id
      end

      it 'not found' do
        get "/api/meals/0"
        expect(response).to have_http_status(404)
      end

      it 'access denied' do
        get "/api/meals/#{other_meal.id}"
        expect(response).to have_http_status(404)
      end
    end

    describe 'update' do
      let(:meal_attr) { FactoryGirl.attributes_for(:meal) }

      it 'success' do
        patch "/api/meals/#{meal.id}", meal: meal_attr
        expect(response).to have_http_status(200)
        
        meal.reload
        expect(meal.calories).to eq meal_attr[:calories]
        expect(meal.description).to eq meal_attr[:description]
        expect(meal.eaten_at).to eq meal_attr[:eaten_at]

        json = JSON.parse(response.body)
        expect(json['id']).to eq meal.id
      end

      it 'not found' do
        patch "/api/meals/0"
        expect(response).to have_http_status(404)
      end

      it 'access denied' do
        patch "/api/meals/#{other_meal.id}"
        expect(response).to have_http_status(404)
      end
    end
  end

  context 'with auth token' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:meals) { user.meals.create(FactoryGirl.attributes_for_list(:meal, 2)) }

    describe 'index' do
      it 'success' do
        get '/api/meals', auth_token: user.auth_token
        expect(response).to have_http_status(200)

        json_arr = JSON.parse(response.body)
        expect(json_arr.length).to eq 2
      end

      it 'invalid token' do
        get '/api/meals', auth_token: 'abc'
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'unauthenticated' do
    it 'index' do
      get '/api/meals'
      expect(response).to have_http_status(401)
    end

    it 'create' do
      post '/api/meals'
      expect(response).to have_http_status(401)
    end

    it 'destroy' do
      delete '/api/meals/1'
      expect(response).to have_http_status(401)      
    end

    it 'show' do
      get '/api/meals/1'
      expect(response).to have_http_status(401)
    end

    it 'update' do
      patch '/api/meals/1'
      expect(response).to have_http_status(401)      
    end
  end
end
