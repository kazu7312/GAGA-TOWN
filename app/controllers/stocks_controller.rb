class StocksController < ApplicationController
  #before_action :logged_in_user, only: [:new, :create, :edit, :update]
  before_action :admin_user

  def new
    @stock = Stock.new(product_id: params[:product_id])
  end

  def create
    @stock = Stock.new(stock_params)
    Stock.where(product_id: @stock.product_id).each do |stock|
      if stock.size_id == @stock.size_id
        flash[:danger] = "同じサイズのストック追加は「ストック数変更」から行ってください。"
        redirect_to root_path
        return
      end
    end
    if @stock.save
      flash[:success] = "新規ストックが登録されました"
      redirect_to root_path
    else
      flash.now[:danger] = "ストック登録に失敗しました"
      render 'new'
    end
  end

  def edit
    @product_id = params[:id]
    @stock_sizes = Stock.where("product_id = ?", params[:id]).order("size_id").to_a
  end

  def update
    @stock = Stock.where("product_id = ?", params[:product_id]).find_by(size_id: params[:size_id])
    @stock.stock += params[:add_stock].to_i
    if @stock.save
      flash[:success] = "ストックが追加されました"
      redirect_to root_path
    else
      flash[:danger] = "ストック追加に失敗しました"
      redirect_to root_path
    end
  end

  private
    def stock_params
      params.require(:stock).permit(:product_id, :size_id, :stock)
    end
end
