require "rails_helper"

RSpec.describe "Ceremonies", type: :request do
  describe "GET /ceremonies/:id/products" do
    let!(:ceremony) { create(:ceremony) }
    let!(:products) { create_list(:product, 15, ceremony: ceremony) }

    subject { get products_ceremony_path(ceremony) }

    context "when the ceremony exists" do
      it "includes pagination metadata" do
        subject

        json_response = JSON.parse(response.body)
        expect(json_response["meta"]).to include("current_page", "total_pages", "total_count")
      end
    end
  end
end
