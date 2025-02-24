require "rails_helper"

RSpec.describe "Products", type: :request do
  let(:deleted_at) { nil }
  let!(:product) { create(:product, deleted_at: deleted_at) }

  subject { get product_path(product) }

  context "when the product is active" do
    it "returns success status" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "returns the product" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(product.id)
      expect(json_response["title"]).to eq(product.title)
      expect(json_response["price"]).to eq(product.price.to_s)
      expect(json_response["currency"]).to eq(product.currency)
    end
  end

  context "when the product is inactive" do
    let(:deleted_at) { Time.current }

    it "is still accessible" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["deleted_at"]).to be_present
    end

    it "returns success status" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  context "when the product doesn't exist" do
    before { product.destroy }

    it "returns a not found error" do
      get product_path(id: product.id)

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Product not found")
    end

    it "returns a not found response" do
      get product_path(id: product.id)

      expect(response).to have_http_status(:not_found)
    end
  end
end
