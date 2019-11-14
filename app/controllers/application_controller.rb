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
      !(params[:book_name].nil? && params[:author_name].nil? && params[:publication_year].nil? && params[:isbn].nil? && params[:comment].nil? && params[:publisher].nil?)
    end
end
