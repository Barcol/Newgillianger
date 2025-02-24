require "rails_helper"

RSpec.describe "PUT/PATCH /products/:id", type: :request do
  let(:product) { create(:product) }
  let(:product_id) { product.id }
  let(:params) { {} }

  subject { put "/products/#{product_id}", params: params, as: :json }

  context "when the request and product id is valid" do
    let(:params) { { title: "Woda muzynianka", price: "10.00", currency: "PLN" } }

    it "updates the product and returns the updated object" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq("Woda muzynianka")
      expect(json_response["price"]).to be_present
      expect(json_response["currency"]).to be_present

      product.reload
      expect(product.title).to eq("Woda muzynianka")
    end

    it "returns ok response" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  context "when the product id is invalid" do
    let(:product_id) { 9999 }
    let(:params) { { title: "Woda muzynianka", price: "10.00", currency: "PLN" } }

    it "returns a not found error" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Product not found")
    end

    it "returns a not found response" do
      subject

      expect(response).to have_http_status(:not_found)
    end
  end

  context "when the request parameters are invalid" do
    let(:params) { { title: "", price: "", currency: "" } }

    it "does not update the product and returns validation errors" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Title can't be blank")
    end

    it "returns unprocessable entity" do
      subject

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
