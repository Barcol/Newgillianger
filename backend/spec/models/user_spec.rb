require 'rails_helper'

RSpec.describe User, type: :model do
  let(:email) { "normalguy@example.com" }
  let(:password) { "password123" }
  let(:password_confirmation) { "password123" }

  subject { build(:user, email: email, password: password, password_confirmation: password_confirmation) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  context "when password is invalid" do
    context "when password is nil" do
      let(:password) { nil }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when password is too long" do
      let(:password) { "a" * 71 }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when password is too short" do
      let(:password) { "short" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when password confirmation is nil" do
      let(:password_confirmation) { nil }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when password confirmation doesn't match password" do
      let(:password_confirmation) { "eciepeciewparapecie" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end
  end

  context "when email format is invalid" do
    context "when email is nil" do
      let(:email) { nil }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when email is too long" do
      let(:email) { "a" * 244 + "@example.com" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when email is without @ symbol" do
      let(:email) { "exampleexample.com" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when email is without domain" do
      let(:email) { "example@" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when email contains spaces" do
      let(:email) { "example @example.com" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end

    context "when email contains multiple @ symbols" do
      let(:email) { "example@example@example.com" }

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end
  end
end
