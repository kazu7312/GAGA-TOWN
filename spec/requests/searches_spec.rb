require 'rails_helper'

RSpec.describe "商品検索", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @brand    = Brand.create!(name: "BEAMS")
      @size     = Size.create!(name: "S")
      @product  = Product.create!(
                    name: "トップス S",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png")
      @user     = User.create!(
                    name:  "Example User",
                    email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: true )
      @user1    = User.create!(
                    name:  "Example User",
                    email: "example1@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: false )
      @file = fixture_file_upload("1057374906.g_400-w_g.jpg", true)
      @stock   = Stock.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    stock:      1000
                  )

    end

  describe "new" do

    it "ヘッダーの検索窓から検索があった場合" do
      @feed_items = Product.all
      get search_path, params:{
        name: @product.name
      }
      expect(response).to have_http_status :success
      expect(response).to render_template root_path
    end

    it "ヘッダーの検索窓への入力に対する検索結果がなかった場合" do
      @feed_items = Product.all
      get search_path, params:{
        name: "トップス M"
      }
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to have_http_status :success
      expect(response).to render_template root_path
    end

    it "ホーム脇のセレクト検索からの検索があった場合" do
      @feed_items = Product.all
      get search_path, params:{
        category_id: @product.category_id,
        brand_id:    @product.brand_id,
        price:       2000
      }
      expect(response).to have_http_status :success
      expect(response).to render_template root_path
    end

    it "ホーム脇のセレクト検索からの検索結果がなかった場合" do
      @feed_items = Product.all
      get search_path, params:{
        category_id: @product.category_id,
        brand_id:    @product.brand_id,
        price:       1000
      }
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to have_http_status :success
      expect(response).to render_template root_path
    end

  end

end
