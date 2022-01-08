require "rails_helper"

RSpec.describe ReceivedPlayersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/received_players").to route_to("received_players#index")
    end

    it "routes to #show" do
      expect(get: "/received_players/1").to route_to("received_players#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/received_players").to route_to("received_players#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/received_players/1").to route_to("received_players#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/received_players/1").to route_to("received_players#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/received_players/1").to route_to("received_players#destroy", id: "1")
    end
  end
end
