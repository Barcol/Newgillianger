require "rails_helper"

RSpec.describe UserCreator do
  let(:params) { { email: "usertest@example.com", password: "password123" } }

  describe ".call" do
    subject { described_class.call(params) }

    context "when params are valid" do
      it "creates a new user" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "returns :user_saved and the created user" do
        result, data = subject

        expect(result).to eq(:user_saved)
        expect(data).to be_a(User)
        expect(data).to be_persisted
        expect(data.email).to eq("usertest@example.com")
      end
    end

    context "when email is already taken" do
      let!(:taken_user) { create(:user, email: "usertest@example.com") }

      it "does not create a new user" do
        expect { subject }.not_to change(User, :count)
      end

      it "returns :email_taken and an empty data" do
        result, data = subject

        expect(result).to eq(:email_taken)
        expect(data).to be_nil
      end
    end

    context "when params are invalid" do
      let(:params) { { email: "invalid_email", password: "short" } }

      it "does not create a new user" do
        expect { subject }.not_to change(User, :count)
      end

      it "returns :validation_error and error messages" do
        result, data = subject

        expect(result).to eq(:validation_error)
        expect(data).to be_a(ActiveModel::Errors)
        expect(data.full_messages).to include("Email is invalid")
        expect(data.full_messages).to include("Password is too short (minimum is 8 characters)")
      end
    end
  end
end
