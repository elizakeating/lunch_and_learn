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

  describe "get user's favorites" do
    it "returns users's favorites" do
      user = User.create(name: "bob", email: "bob@gmail.com", password: "1234", api_key: "abcdefgh")
      favorite_1 = user.favorites.create(country: "thailand", recipe_link: "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html", recipe_title: "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)")
      favorite_2 = user.favorites.create(country: "france", recipe_link: "http://www.food52.com/recipes/351_herb_and_white_wine_granita", recipe_title: "Herb And White Wine Granita")

      get "/api/v1/favorites?api_key=abcdefgh"

      expect(response).to be_successful
      
      favorites = JSON.parse(response.body, symbolize_names: true)

      expect(favorites).to have_key(:data)
      expect(favorites[:data]).to be_an(Array)
      expect(favorites[:data].count).to eq(2)

      favorite = favorites[:data].first

      expect(favorite).to have_key(:id)
      expect(favorite[:id]).to be_a(String)
      
      expect(favorite).to have_key(:type)
      expect(favorite[:type]).to be_a(String)
      expect(favorite[:type]).to eq("favorite")

      expect(favorite).to have_key(:attributes)
      expect(favorite[:attributes]).to be_a(Hash)

      expect(favorite[:attributes]).to have_key(:recipe_title)
      expect(favorite[:attributes][:recipe_title]).to be_a(String)

      expect(favorite[:attributes]).to have_key(:recipe_link)
      expect(favorite[:attributes][:recipe_link]).to be_a(String)

      expect(favorite[:attributes]).to have_key(:country)
      expect(favorite[:attributes][:country]).to be_a(String)

      expect(favorite[:attributes]).to have_key(:created_at)
      expect(favorite[:attributes][:created_at]).to be_a(String)
    end

    it "returns blank array if user has no favorites" do
      user = User.create(name: "bob", email: "bob@gmail.com", password: "1234", api_key: "abcdefgh")

      get "/api/v1/favorites?api_key=abcdefgh"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json).to eq(
        {
          data: []
        }
      )
    end

    it "returns error message if api key is invalid" do
      user = User.create(name: "bob", email: "bob@gmail.com", password: "1234", api_key: "abcdefgh")
      favorite_1 = user.favorites.create(country: "thailand", recipe_link: "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html", recipe_title: "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)")
      favorite_2 = user.favorites.create(country: "france", recipe_link: "http://www.food52.com/recipes/351_herb_and_white_wine_granita", recipe_title: "Herb And White Wine Granita")

      get "/api/v1/favorites?api_key=abcdefghi"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to eq(
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