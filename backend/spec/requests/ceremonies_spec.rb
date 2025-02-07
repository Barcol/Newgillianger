require 'rails_helper'

RSpec.describe "Ceremonies", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/ceremonies/index"
      expect(response).to have_http_status(:success)
    end
  end

end
