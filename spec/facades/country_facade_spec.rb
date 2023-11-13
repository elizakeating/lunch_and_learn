require "rails_helper"

RSpec.describe CountryFacade do
  describe "instance methods" do
    describe "#random_country" do
      it "should return a SINGLE country name" do
        VCR.use_cassette("random_country") do
          country = CountryFacade.new.random_country

          expect(country).to be_a(String)
        end
      end
    end

    describe "#search_country_lat_long" do
      it "should return lat long for country" do
        VCR.use_cassette("france_country_sites") do
          coordinates = CountryFacade.new.search_country_lat_long("France")

          expect(coordinates).to be_an(Array)
          expect(coordinates.count).to eq(2)
        end
      end
    end
  end
end