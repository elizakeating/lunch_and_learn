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

      binding.pry
    end
  end
end