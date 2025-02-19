class ProductsController < ApplicationController
  def index
    @products = Product.active.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      products: @products,
      meta: {
        current_page: @products.current_page,
        total_pages: @products.total_pages,
        total_count: @products.total_count
      }
    }
  end

  def show
    @product = Product.find(params[:id])

    return render json: { error: "Product is inactive", deleted_at: @product.deleted_at }, status: :gone if @product.inactive?

    render json: @product
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
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

  def destroy
    @product = Product.find(params[:id])

    if @product.soft_delete
      render json: { message: "Product successfully deleted" }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def restore
    @product = Product.unscoped.find(params[:id])

    if @product.restore
      render json: { message: "Product successfully restored" }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :currency)
  end
end
