require 'rails_helper'

RSpec.describe "POST /login", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password123") }

  subject { post "/login", params: params }

  context "when credentials are valid" do
    let(:params) { { email: user.email, password: "password123" } }

    it "returns an ok status" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns a JWT token" do
      subject
      expect(JSON.parse(response.body)).to have_key("token")
    end
  end

  context "when user data are invalid" do
    context "when password is incorrect" do
      let(:params) { { email: user.email, password: "wrong_password" } }

      it "returns an unauthorized response status" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an unauthorized error" do
        subject
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid credentials" })
      end
    end

    context "when user does not exist" do
      let(:params) { { email: "fake@example.com", password: "password123" } }

      it "returns an unauthorized response status" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an unauthorized error" do
        subject
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid credentials" })
      end
    end
  end
end
