require 'rails_helper'

RSpec.describe "Ceremonies API", type: :request do
  describe "GET /ceremonies" do
    it "returns a paginated list of ceremonies" do
      Ceremony.create(name: "Ceremony 1", event_date: Time.now + 1.day)
      Ceremony.create(name: "Ceremony 2", event_date: Time.now + 2.days)

      get "/ceremonies"

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to have_key("ceremonies")
      expect(json_response).to have_key("meta")
      expect(json_response["ceremonies"].size).to eq(2)
    end

    it "returns an empty list when no ceremonies exist" do
      get "/ceremonies"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["ceremonies"].size).to eq(0)
    end

    it "returns ceremonies sorted by event_date" do
      Ceremony.create(name: "Ceremony 1", event_date: Time.now + 2.days)
      Ceremony.create(name: "Ceremony 2", event_date: Time.now + 1.day)

      get "/ceremonies"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["ceremonies"].first["name"]).to eq("Ceremony 2")
    end

    it "returns paginated results" do
      10.times { Ceremony.create(name: "Ceremony", event_date: Time.now) }
      get "/ceremonies?page=2&per_page=3"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["ceremonies"].size).to eq(3)
      expect(json_response["meta"]["current_page"]).to eq(2)
    end
  end

  describe "GET /ceremonies/:id" do
    it "returns a specific ceremony by id" do
      ceremony = Ceremony.create(name: "Specific Ceremony", event_date: Time.now + 3.days)

      get "/ceremonies/#{ceremony.id}"

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response["name"]).to eq("Specific Ceremony")
    end

    it "returns a 404 Not Found error if the ceremony does not exist" do
      get "/ceremonies/999"

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("Ceremony not found")
    end
  end

  describe "POST /ceremonies" do
    it "creates a new ceremony" do
      ceremony_params = { ceremony: { name: "New Ceremony", event_date: Time.now + 4.days } }

      post "/ceremonies", params: ceremony_params

      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body)

      expect(json_response["name"]).to eq("New Ceremony")
      expect(Ceremony.count).to eq(1)
    end

    it "returns a 422 Unprocessable Entity error if the ceremony is invalid" do
      ceremony_params = { ceremony: { event_date: Time.now + 4.days } }

      post "/ceremonies", params: ceremony_params

      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)

      expect(json_response["errors"]).to include("Name can't be blank")
      expect(Ceremony.count).to eq(0)
    end

    it "returns a 422 Unprocessable Entity error if the event_date is invalid" do
       ceremony_params = { ceremony: { name: "Zjazd inwalidów", event_date: "dupa" } }

       post "/ceremonies", params: ceremony_params

       expect(response).to have_http_status(:unprocessable_entity)
       json_response = JSON.parse(response.body)
       expect(json_response["errors"]).to include("Event date can't be blank")
       expect(Ceremony.count).to eq(0)
     end

     it "returns a 422 Unprocessable Entity error if the name is too long" do
      long_name = "a" * 256
      ceremony_params = { ceremony: { name: long_name, event_date: Time.now.iso8601 } }
    
      post "/ceremonies", params: ceremony_params
    
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Name is too long (maximum is 255 characters)")
      expect(Ceremony.count).to eq(0)
    end
  end

  describe "DELETE /ceremonies/:id" do
    it "deletes a specific ceremony by id" do
      ceremony = Ceremony.create(name: "Ceremony to Delete", event_date: Time.now.iso8601)
    
      delete "/ceremonies/#{ceremony.id}"
    
      expect(response).to have_http_status(:ok)
    
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Ceremony successfully deleted")
    
      ceremony.reload
      expect(ceremony.deleted_at).not_to be_nil
    end    

    it "returns a 404 Not Found error if the ceremony does not exist" do
      delete "/ceremonies/999"

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("Ceremony not found")
    end
  end
end
