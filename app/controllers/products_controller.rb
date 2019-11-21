class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  def index
    # if word_search
    #   @products = Product.paginate(page: params[:page]).search(params[:word_search]).order(created_at: “DESC”)
    # elsif select_search
    #   @products = Product.paginate(page: params[:page]).search(params[:select_search]).order(created_at: “DESC”)
    # else
    #   @products = Product.paginate(page: params[:page])
    # end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product added!"
      redirect_to login_path
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end


private

  def product_params
     params.require(:product).permit(:name, :category_id, :brand_id,
                                  :price, :detail, :icon)
  end
