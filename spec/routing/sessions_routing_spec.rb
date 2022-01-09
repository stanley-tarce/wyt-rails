require "rails_helper"

RSpec.describe SessionsController, type: :routing do
    it "1. It should route to #callback" do 
        expect(get: "/auth/yahoo_auth/callback").to route_to("sessions#callback")
    end
end