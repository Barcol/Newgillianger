class ProductsController < ApplicationController
  # GET /products
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

  # GET /products/:id
  def show
    @product = Product.find(params[:id])

    return render json: { error: "Product is inactive", deleted_at: @product.deleted_at }, status: :gone if @product.inactive?

    render json: @product
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  # POST /products
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

  # DELETE /products/:id
  def destroy
    @product = Product.find(params[:id])

    if @product.soft_delete
      render json: { message: "Product successfully deleted" }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /products/:id
  def restore
    @product = Product.find(params[:id])

    if @product.restore
      render json: { message: "Product successfully restored" }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /products/:id
  def update
    product = Product.find(params[:id])

    # TODO: find better way to handle product ceremony id update
    product_params.merge(ceremony_id: product.ceremony_id) unless product_params[:ceremony_id].present?

    if product.update(product_params)
      render json: product.as_json(only: [ :title, :price, :currency ]), status: :ok
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :currency, :ceremony_id)
  end
end
