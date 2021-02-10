require 'rails_helper'
require './app/controllers/application_controller'
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/todos", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Todo. As you add validations to Todo, be sure to
  # adjust the attributes here as well.
  before(:example) do 
    cont = ApplicationController.new
      Todo.delete_all
      User.delete_all
    Rails.application.load_seed
    @id = User.first.id
    @todo_id = User.find(@id).todos.first.id 
    @token = cont.encode_token({user_id: @id})
    @valid_headers = {:Authorization => "Bearer #{@token}"}
  end
  after(:example) do
    Todo.delete_all
    User.delete_all
  end
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # TodosController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {
      :Authorization => @token
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      get todos_url, headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get "/todos/#{@todo_id }", headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Todo" do
        expect {
          post todos_url,
               params: { :description => "first", :completed => true  }, headers: @valid_headers, as: :json
        }.to change(Todo, :count).by(1)
      end

      it "renders a JSON response with the new todo" do
        post todos_url,
        params: { :description => "first", :completed => true  }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with no auth" do
      it "does not create a new Todo if no auth" do
        expect {
          post todos_url,
               params: { :description => "first", :completed => true }, as: :json
        }.to change(Todo, :count).by(0)
      end

      it "renders a JSON response with errors for the new todo" do
        post todos_url,
             params: { :description => "first", :completed => true  }, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {:description => "first", :completed => true }
      }

      it "updates the requested todo" do
        patch "/todos/#{@todo_id }", params: { :description => "first", :completed => true }, headers: @valid_headers, as: :json

        expect(Todo.find(@todo_id)[:descreption]).to eq(new_attributes[:descreption])
      end

      it "renders a JSON response with the todo" do

        patch "/todos/#{@todo_id }",
              params: { todo: new_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the todo unautharized" do

        patch "/todos/#{@todo_id }",
              params: { todo: {:description => "first", :completed => true } }, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested todo" do
      expect {
        delete "/todos/#{@todo_id }", headers: @valid_headers, as: :json
      }.to change(Todo, :count).by(-1)
    end
  end
end
