require "rails_helper"

RSpec.describe "Favorite Request" do
  describe "add favorites" do
    it "adds recipe to favorite list for user (valid user)" do
      User.create(name: "bob", email: "bob@gmail.com", password: "1234", api_key: "abcdefgh")

      favorite_info = {
        "api_key": "abcdefgh",
        "country": "thailand",
        "recipe_link": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
        "recipe_title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)"
      }

      post "/api/v1/favorites", params: favorite_info, as: :json

      expect(response).to be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to eq(
        {
          success: "Favorite added successfully"
        }
      )
    end

    it "returns error message if favorite is not created successfuly" do
      User.create(name: "bob", email: "bob@gmail.com", password: "1234", api_key: "abcdefgh")

      favorite_info = {
        "api_key": "abcdefgh",
        "country": "thailand",
        "recipe_link": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html"
      }

      post "/api/v1/favorites", params: favorite_info, as: :json

      expect(response).to_not be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to eq(
        {
          errors: [
            {
              status: "400",
              title: "Validation failed: Recipe title can't be blank"
            }
          ]
        }
      )
    end

    it "returns error message if api key is invalid" do
      User.create(name: "bob", email: "bob@gmail.com", password: "1234", api_key: "abcdefgh")

      favorite_info = {
        "api_key": "hdkewidbnn",
        "country": "thailand",
        "recipe_link": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html"
      }

      post "/api/v1/favorites", params: favorite_info, as: :json

      expect(response).to_not be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to eq(
        {
          errors: [
            {
              status: "400",
              title: "Api key invalid"
            }
          ]
        }
      )
    end
  end
end