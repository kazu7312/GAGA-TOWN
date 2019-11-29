class ItemsController < ApplicationController

  def create
    if params[:quantity].to_i == 0
      flash[:danger] = "購入数を入力してください"
      redirect_to product_path
    else
      # Find associated product and current cart
      chosen_product = Product.find(params[:product_id])
      item_quantity  = params[:quantity].to_i
      item_size      = params[:size_id].to_i
      current_cart   = @current_cart

      # If cart already has this product then find the relevant item and iterate quantity otherwise create a new item for this product
      if current_cart.products.include?(chosen_product)
        # Find the item with the chosen_product
        @item = current_cart.items.find_by(product_id: chosen_product)
        # Iterate the line_item's quantity by one
        if @item.size_id == params[:size_id].to_i
          @item.quantity += item_quantity
        else
          @item           = Item.new
          @item.cart      = current_cart
          @item.product   = chosen_product
          @item.quantity  = item_quantity
          @item.size_id   = item_size
        end
      else
        @item           = Item.new
        @item.cart      = current_cart
        @item.product   = chosen_product
        @item.quantity  = item_quantity
        @item.size_id   = item_size
      end
      # Save and redirect to cart show path
      @item.save
      redirect_to cart_path(current_cart)
    end

  end

  def add_quantity
    @item = Item.find(params[:id])
    @item.quantity += 1
    @item.save
    redirect_to cart_path(@current_cart)
  end

  def reduce_quantity
    @item = Item.find(params[:id])
    if @item.quantity > 1
      @item.quantity -= 1
    end
    @item.save
    redirect_to cart_path(@current_cart)
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to cart_path(@current_cart)
  end
end

private
  def item_params
    params.require(:item).permit(:quantity, :product_id, :cart_id)
  end
