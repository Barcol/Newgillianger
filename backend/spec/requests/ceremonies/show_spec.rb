require "rails_helper"

RSpec.describe "GET /ceremonies", type: :request do
  describe "GET /ceremonies" do
    context "when ceremonies exist" do
      let!(:ceremony1) { create(:ceremony, name: "Ceremony 1") }
      let!(:ceremony2) { create(:ceremony, name: "Ceremony 2") }

      it "returns a paginated list of ceremonies" do
        get "/ceremonies"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("ceremonies")
        expect(json_response).to have_key("meta")
        expect(json_response["ceremonies"].size).to eq(2)
      end

      it "returns ceremonies sorted by event_date" do
        get "/ceremonies"

        json_response = JSON.parse(response.body)
        expect(json_response["ceremonies"].first["name"]).to eq("Ceremony 1")
      end

      it "returns paginated results" do
        10.times { Ceremony.create(name: "Ceremony", event_date: Time.now) }
        get "/ceremonies/page/2?per_page=3"

        json_response = JSON.parse(response.body)
        expect(json_response["ceremonies"].size).to eq(3)
        expect(json_response["meta"]["current_page"]).to eq(2)
      end
    end

    context "when no ceremonies exist" do
      it "returns an empty list" do
        get "/ceremonies"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["ceremonies"].size).to eq(0)
      end
    end
  end
end
