require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    let!(:products) {create_list(:product, 4)}
    before {
      get '/products'
    }
    it('Shows all the products') do
      expect(response).to have_http_status(:ok)
      expect(json_response.length).to eq(4)

    end
  end

  describe "GET /products/:id" do
    let!(:product) { create(:product) }

    it "should return a product" do
      get "/products/#{product.id}"
      expect(response).to have_http_status(:ok)
      expect(json_response["name"]).to eq(product.name)
      expect(json_response["description"]).to eq(product.description)
    end

    it "should return not found" do
      get "/products/100"
      expect(response).to have_http_status(:not_found)
      expect(json_response["errors"]).to include("Product not found")
    end
  end

  describe "POST /products" do
    let(:valid_attributes) { attributes_for(:product) }
    let(:valid_file_path) { Rails.root.join("spec", "fixtures", "files", "image.png") }
    let(:invalid_file_path) { Rails.root.join("spec", "fixtures", "files", "image.HEIC") }
    let(:valid_token) { JWTHelper.generate_jwt_token({user_id: 1}) }
    let(:valid_headers) { { "Authorization": "Bearer #{valid_token}" }}
    context "with valid attributes" do

      it "Should create a product" do
        post "/products", params: valid_attributes, headers: valid_headers
        expect(response).to have_http_status(:created)
        expect(json_response["name"]).to eq(valid_attributes[:name])
        expect(json_response["description"]).to eq(valid_attributes[:description])
        expect(json_response["price"]).to eq(valid_attributes[:price])
      end

      it "should create a product with image" do
        post "/products", params: valid_attributes.merge(images: [fixture_file_upload(valid_file_path, "image/png")]), headers: valid_headers
        expect(response).to have_http_status(:created)
        expect(json_response["images_urls"].count).to eq(1)
      end
    end
    context "with invalid attributes" do

      it "should return error for missing product name" do
        post "/products", params: valid_attributes.merge(name: ""), headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Name can't be blank")
      end

      it "should return error for wrong product image type" do
        post "/products", params: valid_attributes.merge(images: [fixture_file_upload(invalid_file_path, "image/HEIC")]), headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Images Must be a JPEG, PNG or GIF")
      end

      it "should return error for missing product price" do
        post "/products", params: valid_attributes.merge(price: nil), headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Price can't be blank")
      end

      it "should return error for short product description" do
        post "/products", params: valid_attributes.merge(description: "t"), headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Description is too short (minimum is 2 characters)")
      end
    end
  end
  describe "DELETE /products/id" do
    let!(:product) { create(:product) }
    let(:valid_token) { JWTHelper.generate_jwt_token({user_id: 1}) }
    let(:valid_headers) { { "Authorization": "Bearer #{valid_token}" }}

    it "should delete a product" do
      delete "/products/#{product.id}", headers: valid_headers
      expect(response).to have_http_status(:no_content)
      expect(Product.count).to eq(0)
    end

    it "should return not found" do
      delete "/products/100", headers: valid_headers
      expect(response).to have_http_status(:not_found)
      expect(json_response["errors"]).to include("Product not found")
    end
  end

end
