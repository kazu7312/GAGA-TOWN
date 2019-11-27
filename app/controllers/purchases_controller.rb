class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.paginate(page: params[:page])
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new
    @purchase = Purchase.new
    @cart = @current_cart
  end

  def create
    @user = current_user
    @cart = @current_cart
    @cart_items = Item.where(cart_id: @cart.id)
    unless @cart_items.present?
      flash[:danger] = "カートに商品を入れてください"
      redirect_to root_path
    else
      begin
        ActiveRecord::Base.transaction do
          #そのユーザの買う量を変更できないように
          @cart_items.each do |item|
            @stock = Stock.lock.find_by(product_id: item.product_id)
            @stock.stock -= item.quantity
            if @stock.stock >= 0
              @stock.save!
              @purchase = Purchase.new(user_id: @cart.user_id, product_id: item.product_id, total: item.quantity)
              @purchase.attributes = purchase_params
              @purchase.save!
            else
              raise
            end
          end
          @cart.destroy!
        end
        flash[:success] = "ご購入ありがとうございました！"
        redirect_to root_path
      rescue
        p "ロールバック"
        flash[:danger] = "申し訳ありません。カートの商品は品切れとなりました。"
        redirect_to new_purchase_path
      end
    end
  end
end

  private
    def purchase_params
      params.require(:purchase).permit(:destination_name, :destination_postal_code, :destination_address, :credit_number)
    end
