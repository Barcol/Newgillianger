require "rails_helper"

RSpec.describe "POST /ceremonies", type: :request do
  describe "POST /ceremonies" do
    context "when the request is valid" do
      let(:valid_params) { { ceremony: { name: "New Ceremony", event_date: Time.now + 4.days } } }

      it "creates a new ceremony" do
        post "/ceremonies", params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("New Ceremony")
        expect(Ceremony.count).to eq(1)
      end
    end

    context "when the request is invalid" do
      it "returns a 422 Unprocessable Entity error if name is missing" do
        invalid_params = { ceremony: { event_date: Time.now + 4.days } }

        post "/ceremonies", params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Name can't be blank")
      end

      it "returns a 422 Unprocessable Entity error if the event_date is invalid" do
        invalid_params = { ceremony: { name: "Zjazd inwalidów", event_date: "invalid_date" } }

        post "/ceremonies", params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Event date can't be blank")
      end

      it "returns a 422 Unprocessable Entity error if the name is too long" do
        long_name = "a" * 256
        invalid_params = { ceremony: { name: long_name, event_date: Time.now.iso8601 } }

        post "/ceremonies", params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Name is too long (maximum is 255 characters)")
      end
    end
  end
end
