class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :current_cart

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "Please log in with correct user."
        redirect_to(root_url)
      end
    end

    def admin_user
      unless current_user.admin
        flash[:danger] = "Please log in with correct user."
        redirect_to(root_url)
      end
    end


    def search_params?
      !(params[:name].nil? && params[:category_id].nil? && params[:brand_id].nil? && params[:price].nil? && params[:detail].nil? && params[:icon].nil?)
    end

    def current_cart
      if cart = Cart.find_by(:user_id => session[:user_id])
        @current_cart = cart
      else
        if session[:cart_id]
          cart = Cart.find_by(:id => session[:cart_id])
          if cart.present?
            @current_cart = cart
          else
            session[:cart_id] = nil
          end
        end
      end

      if cart == nil
        @current_cart = Cart.create
        @current_cart.user_id = session[:user_id]
        @current_cart.save
        session[:cart_id] = @current_cart.id
      end
    end
end
