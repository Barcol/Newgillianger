require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:title) { "Kreatyna BAOR" }
  let(:price) { "9.99" }
  let(:currency) { "PLN" }
  let(:ceremony) { create(:ceremony) }

  subject { build(:product, title: title, price: price, currency: currency, ceremony: ceremony) }

  context "when creating product and ceremony exists" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    context "without a title" do
      let(:title) { nil }

      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end

    context "without a price" do
      let(:price) { nil }

      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end

    context "without a currency" do
      let(:currency) { nil }

      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end
  end

  context "when creating product and ceremony does not exist" do
    let(:ceremony) { nil }

    it "is not valid" do
      expect(subject).not_to be_valid
    end
  end
end
