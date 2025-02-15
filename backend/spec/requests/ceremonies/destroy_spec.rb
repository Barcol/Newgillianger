require "rails_helper"

RSpec.describe "DELETE /ceremonies/:id", type: :request do
  describe "DELETE /ceremonies/:id" do
    context "when the ceremony exists" do
      let!(:ceremony) { create(:ceremony, name: "Ceremony to Delete") }

      it "deletes a specific ceremony by id" do
        delete "/ceremonies/#{ceremony.id}"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Ceremony successfully deleted")

        ceremony.reload
        expect(ceremony.deleted_at).not_to be_nil
      end
    end

    context "when the ceremony does not exist" do
      it "returns a 404 Not Found error" do
        delete "/ceremonies/999"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Ceremony not found")
      end
    end
  end
end
