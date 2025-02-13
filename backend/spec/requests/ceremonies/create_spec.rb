require "rails_helper"

RSpec.describe "POST /ceremonies", type: :request do
  subject { post "/ceremonies", params:, as: :json }

    context "when the request is valid" do
      let(:params) { { ceremony: { name: "New Ceremony", event_date: Time.now + 4.days } } }

      it "creates a new ceremony" do
        expect { subject }.to change { Ceremony.count }.by(1)
      end

      it "returns proper response with ceremony details" do
        subject
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("New Ceremony")
      end
    end

    context "when the request is invalid" do
      let(:params) { { ceremony: { name: name, event_date: "invalid_date" } } }
      let(:name) { nil }


      it "does not create new ceremony" do
        expect { subject }.to_not change { Ceremony.count }
      end

      it "returns a 422 Unprocessable Entity error" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors data" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Event date can't be blank")
        expect(json_response["errors"]).to include("Name can't be blank")
      end

      context 'when name is too long' do
        let(:name) { "a" * 256 }

        it "returns a 422 Unprocessable Entity error if the name is too long" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["errors"]).to include("Name is too long (maximum is 255 characters)")
        end
      end
    end
end
