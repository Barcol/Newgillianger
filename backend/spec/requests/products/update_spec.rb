require "rails_helper"

RSpec.describe "PUT/PATCH /products/:id", type: :request do
  let!(:product) { create(:product) }

  context "when the request and product id is valid" do
    let!(:valid_params) { { product_id: product.id, title: "Woda muzynianka", price: "10.00", currency: "PLN" } }

    it "updates the product and returns the updated object" do
      put "/products/#{product.id}", params: valid_params, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq("Woda muzynianka")
      expect(json_response["price"]).to be_present
      expect(json_response["currency"]).to be_present

      product.reload
      expect(product.title).to eq("Woda muzynianka")
    end

    it "returns ok response" do
      put "/products/#{product.id}", params: valid_params, as: :json

      expect(response).to have_http_status(:ok)
    end
  end

  context "when the product id is invalid" do
    let!(:valid_params) { { product_id: "123", title: "Woda muzynianka", price: "10.00", currency: "PLN" } }

    it "returns a not found error" do
      put "/products/9999", params: valid_params, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Product not found")
    end

    it "returns a not found response" do
      put "/products/9999", params: valid_params, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context "when the request parameters are invalid" do
    let!(:invalid_params) { { product_id: product.id, title: "", price: "", currency: "" } }

    it "does not update the product and returns validation errors" do
      put "/products/#{product.id}", params: invalid_params, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Title can't be blank")
    end

    it "returns unprocessable entity" do
      put "/products/#{product.id}", params: invalid_params, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
