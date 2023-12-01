FactoryBot.define do
  factory :order do
    user_id {1}
    status { "CART" }
    total_price { "0.0" }

    # Add association to line items
    after(:create) do |order|
      create_list(:line_item, 1, order: order)
    end
  end
end
