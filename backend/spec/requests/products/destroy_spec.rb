require 'rails_helper'

RSpec.describe "Products", type: :request do
  let!(:ceremony) { create(:ceremony) }
  let!(:product) { create(:product, ceremony_id: ceremony.id) }

  subject { delete product_path(product) }

  context "when the product exists" do
    it "soft deletes the product" do
      expect { subject }.to change { product.reload.deleted_at }.from(nil)
    end

    it "returns a success message" do
      subject

      expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Product successfully deleted")
    end

    context "when the product doesn't exist" do
      before { product.destroy } # destroy product before so it can't be found

      it "returns a not found error" do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
