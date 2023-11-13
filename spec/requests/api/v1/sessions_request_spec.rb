require "rails_helper"

RSpec.describe "Sessions Request" do
  describe "log in user" do
    it "logs in a user and returns user info when info is correct" do
      User.create(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", password_confirmation: "treats4lyf", api_key: "api_key")

      user_info = {
        email: "goodboy@ruffruff.com",
        password: "treats4lyf"
      }

      post "/api/v1/sessions", params: user_info, as: :json

      expect(response).to be_successful
      
      user = JSON.parse(response.body, symbolize_names: true)

      expect(user).to be_a(Hash)
      
      expect(user[:data]).to be_a(Hash)

      expect(user[:data]).to have_key(:id)
      expect(user[:data][:id]).to be_a(String)

      expect(user[:data]).to have_key(:type)
      expect(user[:data][:type]).to be_a(String)
      expect(user[:data][:type]).to eq("user")

      expect(user[:data]).to have_key(:attributes)
      expect(user[:data][:attributes]).to be_a(Hash)

      expect(user[:data][:attributes]).to have_key(:name)
      expect(user[:data][:attributes][:name]).to be_a(String)

      expect(user[:data][:attributes]).to have_key(:email)
      expect(user[:data][:attributes][:email]).to be_a(String)

      expect(user[:data][:attributes]).to have_key(:api_key)
      expect(user[:data][:attributes][:api_key]).to be_a(String)
    end

    it "returns error message if info is not correct" do
      User.create(name: "Odell", email: "goodboy@ruffruff.com", password: "treats4lyf", password_confirmation: "treats4lyf", api_key: "api_key")

      user_info = {
        email: "goodboy@ruffruff.com",
        password: "treats5lyf"
      }

      post "/api/v1/sessions", params: user_info, as: :json

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      
      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      
      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)

      expect(error[:errors].first).to have_key(:status)
      expect(error[:errors].first[:status]).to be_a(String)

      expect(error[:errors].first).to have_key(:title)
      expect(error[:errors].first[:title]).to be_an(String)
    end
  end
end