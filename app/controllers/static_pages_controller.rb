class StaticPagesController < ApplicationController

  def home
      # if search_params?
    #     if word_search
    #       @products = Product.paginate(page: params[:page]).word_search(params[:word_search]).order(created_at: “DESC”)
    #     elsif select_search
          # @products = Product.paginate(page: params[:page]).category_id(params[:category_id]).order(created_at: “DESC”)
    #     end
      # else
    @feed_items = Product.paginate(page: params[:page])
      # end
  end

  def help
  end

  def about
  end

  def contact
  end
end
