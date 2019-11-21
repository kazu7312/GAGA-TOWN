class SearchController < ApplicationController

  def new
    @feed_items = Product.all
    @feed_items = @feed_items.where("name like ?", "%" + params[:name] + "%") if params[:name].present?
    @feed_items = @feed_items.where("brand_id = ?", params[:brand_id])        if params[:brand_id].present?
    @feed_items = @feed_items.where("category_id = ?", params[:category_id])  if params[:category_id].present?
    @feed_items = @feed_items.where("price <= ?", params[:price])             if params[:price].present?
    @feed_items = @feed_items.paginate(page: params[:page])

    render 'static_pages/home'

  end

  # def home
  #   if logged_in?
  #     # if word_search
  #     #   @products = Product.paginate(page: params[:page]).word_search(params[:word_search]).order(created_at: “DESC”)
  #     # elsif select_search
  #     #   @products = Product.paginate(page: params[:page]).select_search(params[:price_range, :category_id, :brand_id]).order(created_at: “DESC”)
  #     # else
  #       @products = Product.paginate(page: params[:page])
  #     # end
  #  end
  # end




end
