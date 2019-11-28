class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  def index
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "商品が追加されました!"
      redirect_to login_path
    else
      render 'new'
    end
  end

  def show
    @product       = Product.find(params[:id])

    #Stocksテーブルの中から、商品詳細に表示する商品の
    #idに一致するレコードを全て@product_sizesに代入
    #一つの商品はいくつかのsize_idを持つので、一致するレコードが
    #ハッシュ化され、配列の中に入れ込まれる（[{}, {}]みたいに）
    @product_sizes = Stock.where("product_id = ?", params[:id]).order("size_id").to_a
  end
end


private

  def product_params
     params.require(:product).permit(:name, :category_id, :brand_id,
                                  :price, :detail, :icon)
  end
