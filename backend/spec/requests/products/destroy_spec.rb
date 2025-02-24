require 'rails_helper'

RSpec.describe "Products", type: :request do
  let!(:ceremony) { create(:ceremony) }
  let!(:product) { create(:product, ceremony_id: ceremony.id) }

  context "when the product exists" do
    subject { delete product_path(product) }

    it "soft deletes the product" do
      expect { subject }.to change { product.reload.deleted_at }.from(nil).to(be_within(1.second).of(Time.current))
    end

    it "returns a success message" do
      subject

      expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Product successfully deleted")
    end

    context "when the product doesn't exist" do
      subject { delete product_path(id: 'nonexistent') }

      it "returns a not found error" do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
