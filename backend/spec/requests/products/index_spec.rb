require 'rails_helper'

RSpec.describe ProductsController, type: :request do
  let!(:ceremony) { create(:ceremony) }

  before do
    create_list(:product, 15, ceremony: ceremony)
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
  end
end
