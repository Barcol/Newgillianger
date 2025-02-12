require "rails_helper"

RSpec.describe "POST /ceremonies", type: :request do
  describe "POST /ceremonies" do
    context "when the request is valid" do
      let(:valid_attributes) { attributes_for(:ceremony) }

      it "creates a new ceremony" do
        expect {
          post "/ceremonies", params: { ceremony: valid_attributes }, as: :json
        }.to change(Ceremony, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq(valid_attributes[:name])
        expect(Ceremony.last.name).to eq(valid_attributes[:name])
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
