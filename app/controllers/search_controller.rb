class SearchController < ApplicationController

  def new
    @feed_items = Product.all
    @feed_items = @feed_items.where("name like ?", params[:name] + "%")       if params[:name].present?
    @feed_items = @feed_items.where("brand_id = ?", params[:brand_id])        if params[:brand_id].present?
    @feed_items = @feed_items.where("category_id = ?", params[:category_id])  if params[:category_id].present?
    @feed_items = @feed_items.where("price <= ?", params[:price])             if params[:price].present?
    if @feed_items == []
      flash.now[:danger] = "検索結果がありませんでした"
      @feed_items = Product.all.paginate(page: params[:page], per_page: 20)
    else
      @feed_items = @feed_items.paginate(page: params[:page], per_page: 20)
    end
    render 'static_pages/home'
  end





end
