class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :create, :edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "商品が追加されました!"
      redirect_to new_product_path
    else
      render 'new'
    end
  end

  def show
    if !Product.where(id: params[:id]).exists?
      flash[:danger] = "現在その商品は取り扱われておりません。"
      redirect_to purchases_path
    else
      @product       = Product.find(params[:id])

      #Stocksテーブルの中から、商品詳細に表示する商品の
      #idに一致するレコードを全て@product_sizesに代入
      #一つの商品はいくつかのsize_idを持つので、一致するレコードが
      #ハッシュ化され、配列の中に入れ込まれる（[{}, {}]みたいに）
      @product_sizes = Stock.where("product_id = ?", params[:id]).order("size_id").to_a
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:success] = "商品情報が変更されました"
      redirect_to @product
    else
      flash[:danger] = "商品情報変更に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:success] = "商品は削除されました"
    redirect_to root_url
  end


private

  def product_params
     params.require(:product).permit(:name, :category_id, :brand_id,
                                  :price, :detail, :icon)
  end
end
