require 'rails_helper'

RSpec.describe ProductsController, type: :request do
  let!(:ceremony) { create(:ceremony) }
  let!(:product) { create(:product, :inactive, title: "Kurkuma niedobra") }

  before do
    create_list(:product, 15, ceremony: ceremony)
    create_list(:product, 5, :inactive, ceremony: ceremony)
  end

  context "when products exist" do
    it "returns a paginated list of products" do
      get "/products?page=1&per_page=10"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['products'].length).to eq(10)
      expect(json_response['meta']['current_page']).to eq(1)
      expect(json_response['meta']['total_pages']).to eq(2)
      expect(json_response['meta']['total_count']).to eq(15)
    end

    it "returns the second page of products" do
      get "/products?page=2&per_page=10"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['products'].length).to eq(5)
      expect(json_response['meta']['current_page']).to eq(2)
    end

    it "includes pagination metadata" do
      get "/products?page=1&per_page=10"

      json_response = JSON.parse(response.body)
      expect(json_response["meta"]).to include("current_page", "total_pages", "total_count")
    end

    it "returns only active products" do
      get "/products?page=1&per_page=100"

      json_response = JSON.parse(response.body)
      expect(json_response['products'].length).to eq(15)
      expect(response.body).not_to include("Kurkuma niedobra")
    end
  end
end
