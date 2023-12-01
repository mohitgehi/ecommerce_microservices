class OrdersController < ApplicationController
  before_action :authenticate_user, only: [:create, :index, :destroy]

  def index
    @order = Order.find_by(user_id: @current_user_id, status: 'CART')
    product_ids = @order.line_items.pluck(:product_id)
    products = ProductClient.get_products(product_ids)
    products.each do |product|
      line_item = @order.line_items.find_by(product_id: product["id"])
      product["quantity"] = line_item.quantity
    end
    render json: products, status: :ok
  end

  def create
    @order = Order.find_or_initialize_by(user_id: @current_user_id, status: 'CART')
    line_item = @order.line_items.find_by(product_id: order_params['product_id'])
    if line_item
      line_item.update(quantity: line_item.quantity + order_params['quantity'])
    else
      new_line_item = @order.line_items.build(
        product_id: order_params['product_id'],
        price: order_params['price'],
        quantity: order_params['quantity']
      )
    end
    if @order.save
      render json: { order: @order, products: @order.line_items, message: 'Added to cart' }, status: :ok
    else
      render json: { error: 'Failed to add to cart' }, status: :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find_by(status: "CART", user_id:@current_user_id)
    line_item = @order.line_items.find_by(product_id: order_params['product_id'])
    if(line_item.quantity <= 1)
      if line_item.destroy
        render json: { message: 'Removed from cart' }, status: :ok
      else
        render json: { error: 'Failed to remove from cart' }, status: :unprocessable_entity
      end
    else
      if line_item.update(quantity: line_item.quantity - 1)
        render json: { message: 'Cart updated' }, status: :ok
      else
        render json: { error: 'Failed to update from cart' }, status: :unprocessable_entity
      end
    end

  end

  private
    def order_params
      params.permit(:product_id, :price, :quantity) # Add any other permitted attributes
    end
end
