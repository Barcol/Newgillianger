class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(params[:per_page] || 10)
    render json: {
      products: @products,
      meta: {
        current_page: @products.current_page,
        total_pages: @products.total_pages,
        total_count: @products.total_count
      }
    }
  end

  def create
    result, data = ProductCreator.call(params[:ceremony_id], product_params)

    case result
    when :product_saved
      render json: data, status: :created
    when :ceremony_not_found
      render json: { error: "Ceremony not found" }, status: :not_found
    when :validation_error
      render json: { errors: data }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :currency)
  end
end
