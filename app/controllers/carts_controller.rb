class CartsController < ApplicationController
before_action :current_cart

  def show
    @cart = @current_cart
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
    @cart = @current_cart
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_path
  end
end
