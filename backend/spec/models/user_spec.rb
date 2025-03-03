require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(
      email: "macoomba@sk.pl",
      password: "thisissikret"
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  context "when password format is invalid" do
    it "is not valid without a password" do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with too long password" do
      subject.email = "a" * 256
      expect(subject).not_to be_valid
    end

    it "is not valid with too stort password" do
      subject.email = "shorty"
      expect(subject).not_to be_valid
    end
  end

  context "when email format is invalid" do
    it "is not valid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with too long email" do
      subject.email = "a" * 256
      expect(subject).not_to be_valid
    end

    it "is not valid without @ symbol" do
      subject.email = "exampleexample.com"
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end

    it "is not valid without domain" do
      subject.email = "example@"
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end

    it "is not valid with spaces" do
      subject.email = "example @example.com"
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end

    it "is not valid with multiple @ symbols" do
      subject.email = "example@example@example.com"
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end
  end
end
