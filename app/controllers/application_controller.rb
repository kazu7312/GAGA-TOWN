class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def search_params?
      !(params[:name].nil? && params[:category_id].nil? && params[:brand_id].nil? && params[:price].nil? && params[:detail].nil? && params[:icon].nil?)
    end
end
