require "rails_helper"

RSpec.describe "Ceremonies", type: :request do
  describe "GET /ceremonies/:id/products" do
    let!(:ceremony) { create(:ceremony) }
    let!(:active_products) { create_list(:product, 15, ceremony: ceremony) }
    let!(:inactive_products) { create_list(:product, 5, :inactive, ceremony: ceremony) }
    let!(:product) { create(:product, :inactive, title: "Kurkuma niedobra") }

    subject { get products_ceremony_path(ceremony) }

    context "when the ceremony exists" do
      it "returns a successful response" do
        subject

        expect(response).to have_http_status(:ok)
      end

      it "returns a list of products" do
        subject

        json_response = JSON.parse(response.body)
        expect(json_response["products"].length).to eq(15)
      end

      it "returns only active products" do
        subject

        json_response = JSON.parse(response.body)
        expect(json_response['products'].length).to eq(15)
        expect(response.body).not_to include("Kurkuma niedobra")
      end

      context "when given with pagination parameters" do
        subject { get products_ceremony_path(ceremony), params: { page: 2, per_page: 5 } }

        it "returns only requested products" do
          subject

          json_response = JSON.parse(response.body)
          expect(json_response["products"].length).to eq(5)
          expect(json_response["meta"]["current_page"]).to eq(2)
        end
      end
    end

    context "when the ceremony doesn't exist" do
      subject { get products_ceremony_path(id: "wrongid") }

      it "returns a not found response" do
        subject

        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        subject

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Ceremony not found")
      end
    end
  end
end
