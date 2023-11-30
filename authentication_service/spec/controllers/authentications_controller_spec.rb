require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  let(:valid_login_attributes) do
    attributes_for(:user)
  end
  let(:valid_register_attributes) do
    valid_login_attributes.merge(password_confirmation: valid_login_attributes[:password])
  end
  describe "register" do
    context "With valid parameters" do
      before { post :register, params: valid_register_attributes }
      it "Creates a user" do
        expect(User.count).to eq(1)
        expect(response).to have_http_status(:created)
      end
    end
  end
end
