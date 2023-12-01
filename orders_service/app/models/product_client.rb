require 'httpparty'
class ProductClient
  def self.get_products(product_ids)
    response = HTTParty.get('http://localhost:3002/products', body:  {product_ids: product_ids})
    if response.success?
      response.parsed_response
    else
      render json: {message: 'Failed to retrieve products'}, status: :unprocessable_entity
    end
  end
end
