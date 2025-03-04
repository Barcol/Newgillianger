require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user_params) { { user: { email: "usertest@example.com", password: "password123", password_confirmation: "password123" } } }
  let(:params) { user_params }

  subject { post "/users", params: params, as: :json }

  context "when the request is valid" do
    it "creates a new user" do
      expect { subject }.to change(User, :count).by(1)
    end

    it "returns proper response" do
      subject
      expect(response).to have_http_status(:created)
    end

    it "returns proper message with user details" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["email"]).to eq("usertest@example.com")
    end
  end

  context "when the email is already taken" do
    let!(:existing_user) { create(:user, email: "usertest@example.com") }

    it "does not create a new user" do
      expect { subject }.not_to change(User, :count)
    end

    it "returns conflict status" do
      subject
      expect(response).to have_http_status(:conflict)
    end

    it "returns an error message" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Email address is already in use")
    end
  end

  context "when the password is invalid" do
    let(:params) { { user: { email: "usertest@example.com", password: "short", password_confirmation: "short" } } }

    it "does not create a new user" do
      expect { subject }.not_to change(User, :count)
    end

    it "returns unprocessable_entity status" do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns validation errors" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("password" => [ "is too short (minimum is 8 characters)" ])
    end
  end

  context "when the password confirmation is invalid" do
    context "when the password confirmation doesn't match password" do
      let(:params) { { user: { email: "usertest@example.com", password: "goodpassword", password_confirmation: "wrongpassword" } } }

      it "does not create a new user" do
        expect { subject }.not_to change(User, :count)
      end

      it "returns unprocessable_entity status" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("password_confirmation" => [ "doesn't match Password" ])
      end
    end

    context "when the password confirmation is empty" do
      let(:params) { { user: { email: "usertest@example.com", password: "password", password_confirmation: nil } } }

      it "does not create a new user" do
        expect { subject }.not_to change(User, :count)
      end

      it "returns unprocessable_entity status" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("password_confirmation" => [ "can't be blank" ])
      end
    end
  end

  context "when the email is invalid" do
    let(:params) { { user: { email: "usertest", password: "password123" } } }

    it "does not create a new user" do
      expect { subject }.not_to change(User, :count)
    end

    it "returns unprocessable_entity status" do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns validation errors" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("email" => [ "is invalid" ])
    end
  end
end
