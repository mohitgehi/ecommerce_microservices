require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do
    let!(:orders) {create_list(:order, 1)}
    let(:valid_token) { JWTHelper.generate_jwt_token({user_id: 1}) }
    let(:valid_headers) { { "Authorization": "Bearer #{valid_token}" }}
    let(:product) {create(:product)}
    let!(:product_ids) {[1]}
    let(:product_list) {[
      {
          'id': 1,
          'name': "Mediocre Paper Lamp",
          'description': "Sit qui labore. Sunt ut voluptas. Tenetur sit voluptatum.",
          'price': "82.88",
          'images_urls': [
              "http://localhost:3002/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTUsInB1ciI6ImJsb2JfaWQifX0=--d71c865192156bdb006e0b3a359fcd04c637a93c/image.png"
          ]
        }].as_json}
    before {
      allow(ProductClient).to receive(:get_products).and_return(product_list)
      get '/orders', headers: valid_headers
    }
    it('Shows all the products') do
      expect(response).to have_http_status(:ok)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['id']).to eq(product_list[0]["id"])
      expect(json_response[0]['quantity']).to eq(product_list[0]["quantity"])
    end
  end

  describe "POST /orders" do

  end
end
