require 'rails_helper'

RSpec.describe "products#edit, update", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @category1 = Category.create!(name: "トップス2")
      @brand = Brand.create!(name: "BEAMS")
      @brand1 = Brand.create!(name: "adidas")
      @size     = Size.create!(name: "S")
      @product  = Product.create!(name: "トップス S",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png")
      @user     = User.create!(name:  "Example User",
                    email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: true )
      @user1    = User.create!(name:  "Example User",
                    email: "example1@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: false )

    end

  describe "show" do

    it "商品詳細ページへ遷移" do
      @stock    = Stock.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    stock:      1000
                  )
      log_in_as(@user)
      get product_path(@product)
      expect(response).to have_http_status :success
      expect(response).to render_template "products/show"
    end

    it "商品が存在していない場合" do
      log_in_as(@user)
      get product_path(id: 999999)
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "purchases/index"
    end
  end
end
