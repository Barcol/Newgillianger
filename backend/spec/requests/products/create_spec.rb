require 'rails_helper'

RSpec.describe ProductsController, type: :request do
  let!(:ceremony) { create(:ceremony) }
  let(:valid_attributes) { { title: "Krakresy", price: "19.99", currency: "PLN" } }

  context "POST /products" do
    subject { post "/products", params: params }

    context "when the request is valid" do
      let(:params) { { product: valid_attributes, ceremony_id: ceremony.id } }

      it "creates a new product" do
        expect { subject }.to change(Product, :count).by(1)
      end

      it "returns proper response" do
        subject

        expect(response).to have_http_status(:created)
      end

      it "returns proper product details" do
        subject

        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq("Krakresy")
      end
    end

    context "when the request is invalid" do
      let(:params) { { product: { title: "", price: "", currency: "" }, ceremony_id: ceremony.id } }

      it "does not create a new product" do
        expect { subject }.not_to change(Product, :count)
      end

      it "returns a 422 Unprocessable Entity error" do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors data" do
        subject

        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include(
          "currency" => [ "can't be blank" ],
          "price" => [ "can't be blank", "is not a number" ],
          "title" => [ "can't be blank", "is too short (minimum is 1 character)" ]
        )
      end

      context "when the request ceremony id is invalid" do
        let(:params) { { product: { title: "Dobre ziemniaki" }, ceremony_id: "bad-uuid" } }

        it "returns 404" do
          subject

          json_response = JSON.parse(response.body)
          expect(json_response['title']).not_to eq("Dobre ziemniaki")
          expect(json_response['error']).to eq("Ceremony not found")
        end

        it "returns 404 Not found error" do
          subject

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
