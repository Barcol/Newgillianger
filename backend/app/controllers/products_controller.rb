class ProductsController < ApplicationController
  def create
    @ceremony = Ceremony.find(params[:ceremony_id])
    @product = @ceremony.products.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :currency)
  end
end
