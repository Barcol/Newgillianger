require 'rails_helper'

RSpec.describe Product, type: :model do
  subject {
    described_class.new(
      title: "Kreatyna BAOR",
      price: "9.99",
      currency: "PLN",
      ceremony: ceremony
    )
  }

  context "when creating product and ceremony exists" do
    let!(:ceremony) { create(:ceremony) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a title" do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a price" do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a currency" do
      subject.currency = nil
      expect(subject).to_not be_valid
    end
  end

  context "when creating product and ceremony does not exists" do
    let!(:ceremony) { nil }
    
    it "is valid with valid attributes" do
      expect(subject).not_to be_valid
    end
  end
end
