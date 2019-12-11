require 'rails_helper'

RSpec.describe "products#destroy", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @brand    = Brand.create!(name: "BEAMS")
      @size     = Size.create!(name: "S")
      @size1     = Size.create!(name: "M")
      @product  = Product.create!(name: "トップス S",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png")
      @product1  = Product.create!(name: "トップス M",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png")
      @user     = User.create!(name: "Example User",
                    email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: true )
      @cart     = Cart.create!(user_id: @user.id)

    end

  describe "create" do

    it "お気に入り登録する場合" do
      log_in_as(@user)
      get "/products/#{@product.id}"
      count = Favorite.count
      post favorites_path, params: {
        product_id: @product.id,
        user_id:    @user.id,
        }
      expect(count+1).to eq Favorite.count
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template root_path
    end

  end

  describe "destroy" do

    it "お気に入り登録を解除する場合" do
      @favorites = Favorite.create!(
                    user_id:    @user.id,
                    product_id: @product.id
                  )
      log_in_as(@user)
      get "/products/#{@product.id}"
      count = Favorite.count
      delete favorite_path, params: {
        product_id: @product.id,
        user_id:    @user.id,
        }
      expect(count-1).to eq Favorite.count
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template root_path
    end
  end
end
