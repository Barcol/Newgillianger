require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:deleted_at) { nil }
  let!(:product) { create(:product, deleted_at: deleted_at) }

  subject { post restore_product_path(product) }

  context "when restoring a soft-deleted, existing product" do
    let(:deleted_at) { Time.current }

    it "restores the product" do
      expect { subject }.to change { product.reload.deleted_at }.from(be_within(1.second).of(deleted_at)).to(nil)
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
    subject { post restore_product_path(id: 'nonexistent') }

    it "returns a not found error" do
      subject

      expect(response).to have_http_status(:not_found)
    end
  end
end
