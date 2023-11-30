require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  let(:valid_login_attributes) { attributes_for(:user) }
  let(:valid_register_attributes) do
    valid_login_attributes.merge(password_confirmation: valid_login_attributes[:password])
  end
  describe "POST /register" do
    context "With valid parameters" do
      before do
        post '/register', params: valid_register_attributes
      end

      it "Creates a user" do
        expect(User.count).to eq(1)
      end
      it "returns a jwt token" do
        expect(response).to have_http_status(:created)
        expect(json_response['token']).not_to be_nil
      end
      it "returns success message" do
          expect(json_response['message']).to eq('User was successfully registered')
      end
      it "User already registered error message" do
        post '/register', params: valid_register_attributes
        expect(json_response['errors']).to include("Email has already been taken")
      end
    end
    context "With invalid parameters" do
      RSpec.shared_examples 'Registration Error' do |error_message, extra_attributes|
        let(:user_count) { 1 }
        it "when #{error_message}" do
          post '/register', params: valid_register_attributes.merge(extra_attributes)
          expect(User.count).to be(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['errors']).to include(error_message)
        end
      end

      it_behaves_like 'Registration Error', "Password confirmation doesn't match Password", password_confirmation: "wrong_password"
      it_behaves_like 'Registration Error', "Email can't be blank", email: ""
      it_behaves_like 'Registration Error', "Password can't be blank", password: ""
      it_behaves_like 'Registration Error', "Email is invalid", email: "mohit@coffeebeansio"
    end
  end
  describe "POST /login" do

    before do
      # post '/register', params: valid_register_attributes
      create(:user, valid_register_attributes)
    end
    context "with valid parameters" do
      it("Should login successfully") do
        post '/login', params: {email: valid_register_attributes[:email], password: valid_register_attributes[:password]}
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do

      RSpec.shared_examples 'Login Error' do |error_message, extra_attributes|
        let(:user_count) { 1 }
        it "when #{error_message}" do
          post '/login', params: valid_login_attributes.merge(extra_attributes)
          expect(response).to have_http_status(:unauthorized)
          expect(json_response['errors']).to include(error_message)
        end
      end

      it_behaves_like 'Login Error', "Invalid email or password", email: ""
      it_behaves_like 'Login Error', "Invalid email or password", password: ""
      it_behaves_like 'Login Error', "Invalid email or password", email: "mohit@coffeebeans.io", password: 'wrong_password'
    end
  end
end
