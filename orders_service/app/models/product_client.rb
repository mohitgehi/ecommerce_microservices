require 'httpparty'
class ProductClient
  def self.get_products(product_ids)
    response = HTTParty.get('http://localhost:3002/products', body:  {product_ids: product_ids})
    response.parsed_response
  end
end
