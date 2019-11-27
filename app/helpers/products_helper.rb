module ProductsHelper

  def product_size
    Size.find(Stock.find_by(product_id: @product.id).size_id).name
  end
  def stock_amount
    Stock.find_by(product_id: @product.id).stock
  end

end
