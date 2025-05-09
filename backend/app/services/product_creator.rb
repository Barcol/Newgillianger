class ProductCreator < BaseService
  def initialize(ceremony_id, product_params)
    @ceremony_id = ceremony_id
    @product_params = product_params
  end

  def call
    return :ceremony_not_found unless ceremony

    product = ceremony.products.new(@product_params)
    if product.save
      [ :product_saved, product ]
    else
      [ :validation_error, product.errors ]
    end
  end

  private

  attr_reader :ceremony_id

  def ceremony
    @ceremony ||= Ceremony.find_by(id: ceremony_id)
  end
end
