require "rails_helper"

RSpec.describe VideoFacade do
  describe "instance methods" do
    describe "#video_by_country" do
      it "should return a video object based on country search" do
        VCR.use_cassette("learning_resources_laos") do
          video = VideoFacade.new.video_by_country("laos")

          expect(video).to be_a(Video)
          expect(video.title).to be_a(String)
          expect(video.youtube_video_id).to be_a(String)
        end
      end

      it "should return [] if no videos based on country search" do
        VCR.use_cassette("no_media_search") do
          video = VideoFacade.new.video_by_country("thisisnotacountry")

          expect(video).to eq({})
        end
      end
    end
  end
end