require 'rails_helper'

RSpec.describe "Products", type: :request do
  let!(:ceremony) { create(:ceremony) }
  let!(:product) { create(:product, ceremony_id: ceremony.id, deleted_at: Time.current) }

  subject { post restore_product_path(product) }

  context "when restoring a soft-deleted, existing product" do
    it "restores the product" do
      expect { subject }.to change { product.reload.deleted_at }.to(nil)
    end

    it "returns a success message" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Product successfully restored")
    end

    it "returns a success response" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  context "when the product is not soft-deleted" do
    before { product.update(deleted_at: nil) }

    it "doesn't change the product" do
      expect { subject }.not_to change { product.reload.deleted_at }
    end

    it "returns a success message" do
      subject

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Product successfully restored")
    end
  end

  context "when the product doesn't exist" do
    before { product.destroy } # destroy product so it doesnt exists for 100%

    it "returns a not found error" do
      subject

      expect(response).to have_http_status(:not_found)
    end
  end
end
