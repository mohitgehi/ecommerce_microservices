class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :destroy]
  before_action :authenticate_user, only: [:create, :destroy, :update]
  def index
    if product_params[:product_ids].present?
      @products = Product.where(id: product_params[:product_ids])
      render json:  @products, status: :ok
    else
      @products = Product.all
      render json:  @products, status: :ok
    end
  end

  def show
    render  json: @product, status: :ok
  end
  def create
    @product = Product.new(product_params)
    if @product.save
      render json:  @product, status: :created
    else
      render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
    end
  end
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
      Rails.logger.error @product.errors.full_messages.join(', ')
    end
  end
  def destroy
    if @product.destroy
      head :no_content
    else
      render json: { errors: 'Failed to delete the product' }, status: :internal_server_error
    end
  end
  private
    def product_params
      params.permit(:name, :description, :price, product_ids: [], images: []) # Add any other permitted attributes
    end
    def set_product
      begin
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {errors: "Product not found" }, status: :not_found
      end


    end
end
