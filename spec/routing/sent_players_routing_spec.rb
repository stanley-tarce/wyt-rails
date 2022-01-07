require "rails_helper"

RSpec.describe SentPlayersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sent_players").to route_to("sent_players#index")
    end

    it "routes to #show" do
      expect(get: "/sent_players/1").to route_to("sent_players#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sent_players").to route_to("sent_players#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sent_players/1").to route_to("sent_players#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sent_players/1").to route_to("sent_players#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sent_players/1").to route_to("sent_players#destroy", id: "1")
    end
  end
end
