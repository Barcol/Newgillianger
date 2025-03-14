require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user) }
  let(:secret_key) { Rails.application.config.credentials_secret_key }
  let(:token) { JWT.encode({ user_id: user.id }, secret_key) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  subject { patch "/users/#{user.id}", params: params, headers: headers }

  context "when the request is valid" do
    let(:params) { { user: { email: "newemail@example.com" } } }

    it "returns ok response status" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "updates the user's email" do
      expect { subject }.to change { user.reload.email }.to("newemail@example.com")
    end

    it "returns success message" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response).to include("message" => "User successfully updated")
    end
  end

  context "when the email is invalid" do
    let(:params) { { user: { email: "invalidemail" } } }

    it "returns unprocessable_entity status" do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns invalid email message" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Email is invalid")
    end
  end

  context "when the email is already taken" do
    let(:another_user) { create(:user) }
    let(:params) { { user: { email: another_user.email } } }

    it "returns unprocessable_entity status" do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns email taken message" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Email has already been taken")
    end

    it "does not change user email" do
      original_email = user.email
      subject
      expect(user.reload.email).to eq(original_email)
    end
  end

  context "when password is in params" do
    let(:original_password_digest) { user.password_digest }
    let(:params) { { user: { email: "newemail@example.com", password: "new_password", password_confirmation: "new_password" } } }

    it "returns ok response status" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "does not update the user's password" do
      subject
      user.reload

      expect(user.password_digest).to eq(original_password_digest)
      expect(user.authenticate("new_password")).to be false
    end

    it "updates the email despite password in params" do
      expect { subject }.to change { user.reload.email }.to("newemail@example.com")
    end
  end

  context "when the user is not authorized" do
    let(:another_user) { create(:user) }
    let(:unauthorized_token) { JWT.encode({ user_id: another_user.id }, secret_key) }
    let(:headers) { { "Authorization" => "Bearer #{unauthorized_token}" } }
    let(:params) { { user: { email: "newemail@example.com" } } }

    it "returns forbidden status" do
      subject
      expect(response).to have_http_status(:forbidden)
    end

    it "returns forbidden message" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Forbidden")
    end
  end
end
