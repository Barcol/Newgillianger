require "rails_helper"

RSpec.describe "PUT/PATCH /ceremonies/:id", type: :request do
  let!(:ceremony) { Ceremony.create(name: "Bijatyka", event_date: Time.now + 2.days) }

  describe "PUT/PATCH /ceremonies/:id" do
    context "when the request and ceremony id is valid" do
      let(:valid_params) { { ceremony: { name: "Abordaz", event_date: Time.now + 4.days } } }

      it "updates the ceremony and returns the updated object" do
        put "/ceremonies/#{ceremony.id}", params: valid_params, as: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["name"]).to eq("Abordaz")
        expect(json_response["event_date"]).to be_present

        ceremony.reload
        expect(ceremony.name).to eq("Abordaz")
      end
    end

    context "when the ceremony id is invalid" do
      let(:valid_params) { { ceremony: { name: "Abordaz", event_date: Time.now + 4.days } } }

      it "returns a not found error" do
        put "/ceremonies/9999", params: valid_params, as: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Ceremony not found")
      end
    end

    context "when the request parameters are invalid" do
      let(:invalid_params) { { ceremony: { name: "", event_date: "" } } }

      it "does not update the ceremony and returns validation errors" do
        put "/ceremonies/#{ceremony.id}", params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to include("Name can't be blank")
      end
    end
  end
end
