require "rails_helper"

RSpec.describe "Learning Resources Request" do
  it "return learning materials for a country" do
    VCR.use_cassette("learning_resources_laos") do
      get "/api/v1/learning_resources", params: {country: "laos"}

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:data)
      
      expect(json[:data]).to have_key(:type)
      expect(json[:data][:type]).to eq("learning_resource")
      
      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a(Hash)

      expect(json[:data][:attributes]).to have_key(:country)
      expect(json[:data][:attributes][:country]).to be_a(String)
      expect(json[:data][:attributes][:country]).to eq("laos")

      expect(json[:data][:attributes]).to have_key(:video)
      expect(json[:data][:attributes][:video]).to be_a(Hash)

      expect(json[:data][:attributes][:video]).to have_key(:title)
      expect(json[:data][:attributes][:video][:title]).to be_a(String)

      expect(json[:data][:attributes][:video]).to have_key(:youtube_video_id)
      expect(json[:data][:attributes][:video][:youtube_video_id]).to be_a(String)

      expect(json[:data][:attributes]).to have_key(:images)
      expect(json[:data][:attributes][:images]).to be_an(Array)

      expect(json[:data][:attributes][:images].first).to have_key(:alt_tag)
      expect(json[:data][:attributes][:images].first[:alt_tag]).to be_a(String)

      expect(json[:data][:attributes][:images].first).to have_key(:url)
      expect(json[:data][:attributes][:images].first[:url]).to be_a(String)
    end
  end

  it "returns empty objects for video and images if country does not return any results" do
    VCR.use_cassette("no_media_search") do
      get "/api/v1/learning_resources", params: {country: "thisisnotacountry"}

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to eq(
        {
          data: {
            id: nil,
            type: "learning_resource",
            attributes: {
              country: "thisisnotacountry",
              video: {},
              images: []
            }
          }
        }
      )
    end
  end
end