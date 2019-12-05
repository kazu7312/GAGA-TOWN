class PurchasesController < ApplicationController
  before_action :logged_in_user
  before_action :current_cart

  def index
    @purchases = Purchase.paginate(page: params[:page]).where(user_id: current_user).order(created_at: "DESC")
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
            @stock = Stock.lock.where(product_id: item.product_id).find_by(size_id: item.size_id)
            @stock.stock -= item.quantity
            if @stock.stock >= 0
              @stock.save!
              @purchase = Purchase.new(user_id: @cart.user_id, product_id: item.product_id, total: item.quantity, size_id: item.size_id, product_name: Product.find(item.product_id).name, category_name: Category.find(Product.find(item.product_id).category_id).name, brand_name: Brand.find(Product.find(item.product_id).brand_id).name, price: Product.find(item.product_id).price, detail: Product.find(item.product_id).detail, icon: Product.find(item.product_id).icon)
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
        flash[:danger] = "申し訳ありません。カート商品の在庫が不足しております。"
        redirect_to new_purchase_path
      end
    end
  end

  private
    def purchase_params
      params.require(:purchase).permit(:destination_name, :destination_postal_code, :destination_address, :credit_number)
    end
end
