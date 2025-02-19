require "rails_helper"

RSpec.describe ProductCreator do
  let(:ceremony) { create(:ceremony) }
  let(:valid_params) { { title: "New Product", price: "19.99", currency: "PLN" } }

  describe ".call" do
    subject { described_class.call(ceremony.id, params) }

    context "when params are valid" do
      let(:params) { valid_params }

      it "creates a new product" do
        expect { subject }.to change(Product, :count).by(1)
      end

      it "returns :product_saved and the created product" do
        result, product = subject
        
        expect(result).to eq(:product_saved)
        expect(product).to be_a(Product)
        expect(product).to be_persisted
      end
    end

    context "when ceremony does not exist" do
      subject { described_class.call(nil, valid_params) }

      it "returns :ceremony_not_found" do
        result, _ = subject
        expect(result).to eq(:ceremony_not_found)
      end

      it "does not create a product" do
        expect { subject }.not_to change(Product, :count)
      end
    end

    context "when params are invalid" do
      let(:params) { { title: "", price: "invalid", currency: "" } }

      it "returns :validation_error and error messages" do
        result, errors = subject
        expect(result).to eq(:validation_error)
        expect(errors).to be_a(ActiveModel::Errors)
      end

      it "does not create a product" do
        expect { subject }.not_to change(Product, :count)
      end

      it "returns specific error messages" do
        _, errors = subject
        expect(errors.messages).to include(
          title: include("can't be blank"),
          price: include("is not a number"),
          currency: include("can't be blank")
        )
      end
    end
  end
end
