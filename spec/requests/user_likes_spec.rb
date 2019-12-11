require 'rails_helper'

RSpec.describe "ユーザー情報変更", type: :request do

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
    @favorite = Favorite.create!(
                  product_id: @product.id,
                  user_id:    @user.id
    )
  end

  describe "edit" do

    it "お気に入り一覧ページを表示" do
      log_in_as(@user)
      get likes_user_path(@user)
      expect(response).to have_http_status :success
      expect(response).to render_template "users/likes"
    end
  end
end
