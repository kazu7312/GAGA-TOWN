module ProductsHelper


  # def product_size
  #   Size.where(Stock.where(product_id: @product.id)[:size_id])
  # end
  #
  #
  def each_size(size_id)
    Size.find(size_id).name
  end
  #
  #
  # def stock_amount
  #   Stock.find_by(product_id: @product.id).stock
  # end
  #
  def each_amount(size_id)
    Stock.where(product_id: @product.id).find_by(size_id: size_id).stock
  end
  #
  # def stocks(size_id)
  #   Stock.where(product_id: @product.id).find_by(size_id: size_id)
  # end
  #
  # def size_ids(hoge)
  #   size_ids = []
  #   hoge.each do |id|
  #     size_ids << id[:size_id]
  #   end
  #   return size_ids.sort
  # end

end
