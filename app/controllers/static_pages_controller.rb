class StaticPagesController < ApplicationController

  def home
    @feed_items = Product.all.order(created_at: "DESC").paginate(page: params[:page], per_page: 20)
  end

#   def help
#   end
#
#   def about
#   end
#
#   def contact
#   end
end
