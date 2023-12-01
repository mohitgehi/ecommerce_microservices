FactoryBot.define do
  factory :line_item do
    product_id {1}
    price { "10.00" }
    quantity { 2 }
    order

    # Add more traits or customization as needed
  end
end
