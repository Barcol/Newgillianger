require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user) }
  let(:secret_key) { Rails.application.config.credentials_secret_key }
  let(:token) { JWT.encode({ user_id: user.id }, secret_key) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  subject { patch "/users/#{user.id}", params: params, headers: headers }

  context "when the request header is valid" do
    let(:params) { { user: { email: user.email } } }

    it "returns ok response status" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "allows the user to do things that only a logged in user can" do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response).to include("message" => "User successfully updated")
    end
  end

  context "when header provided is invalid" do
    context "when there is an empty header" do
      let(:params) { { user: { email: user.email } } }
      let(:headers) { nil }

      it "returns unauthorized response status" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error message" do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response).to include("error" => "Unauthorized")
      end
    end

    context "when there is an empty token" do
      let(:params) { { user: { email: user.email } } }
      let(:token) { nil }

      it "returns unauthorized response status" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error message" do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response).to include("error" => "Unauthorized")
      end
    end

    context "when there is an invald token" do
      let(:params) { { user: { email: user.email } } }
      let(:token) { "letmein" }

      it "returns unauthorized response status" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized error message" do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response).to include("error" => "Unauthorized")
      end
    end
  end
end
