require 'rails_helper'

RSpec.describe "products#edit, update", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @category1 = Category.create!(name: "トップス2")
      @brand = Brand.create!(name: "BEAMS")
      @brand1 = Brand.create!(name: "adidas")
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
      @file = fixture_file_upload("1057374906.g_400-w_g.jpg", true)
    end

  describe "edit" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      get edit_product_path(@product)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "管理者でないユーザーの場合、homeへリダイレクト" do
      log_in_as(@user1)
      get edit_product_path(@product)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "管理者ユーザーでログイン" do
      log_in_as(@user)
      get edit_product_path(@product)
      expect(response).to have_http_status :success
      expect(response).to render_template "products/edit"
    end

  end

  describe "update" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      name = "トップス M"
      category_id = 2
      brand_id = 2
      price = 2000
      detail = "今冬一番人気"
      file = @file
      patch product_path(@product), params: { product: { name: name,
                      category_id: category_id,
                      brand_id: brand_id,
                      price: price,
                      detail: detail,
                      icon: file } }
      @product.reload
      expect(@product.name).not_to eq name
      expect(@product.category_id).not_to eq category_id
      expect(@product.brand_id).not_to eq brand_id
      expect(@product.price).not_to eq price
      expect(@product.detail).not_to eq detail
      expect(@product.icon).not_to eq file
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "管理者でないユーザーとしてログインした場合、homeへリダイレクト" do
      log_in_as(@user1)
      name = "Coat M"
      category_id = 2
      brand_id = 2
      price = 2000
      detail = "今冬一番人気"
      file = @file
      patch product_path(@product), params: { product: { name: name,
                      category_id: category_id,
                      brand_id: brand_id,
                      price: price,
                      detail: detail,
                      icon: file } }
      @product.reload
      expect(@product.name).not_to eq name
      expect(@product.category_id).not_to eq category_id
      expect(@product.brand_id).not_to eq brand_id
      expect(@product.price).not_to eq price
      expect(@product.detail).not_to eq detail
      expect(@product.icon).not_to eq file
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "管理者で商品情報変更時、誤った入力がされた場合、エラーメッセージと共にproduct#newへ遷移" do
      log_in_as(@user)
      name = ""
      category_id = 0
      brand_id = 0
      price = 100
      detail = ""
      file = @file
      patch product_path(@product), params: { product: { name: name,
                      category_id: category_id,
                      brand_id: brand_id,
                      price: price,
                      detail: detail,
                      icon: file } }
      @product.reload
      expect(@product.name).not_to eq name
      expect(@product.category_id).not_to eq category_id
      expect(@product.brand_id).not_to eq brand_id
      expect(@product.price).not_to eq price
      expect(@product.detail).not_to eq detail
      expect(@product.icon).not_to eq file
      assert_select "div#error_explanation"
      expect(response).to render_template "products/edit"
    end


    it "管理者で商品情報変更時、正しく商品追加される場合" do
      log_in_as(@user)
      name = "Coat M"
      category_id = @category1.id
      brand_id = @brand1.id
      price = 1500
      detail = "今冬一番人気"
      file = @file
      patch product_path(@product), params: { product: { name: name,
                      category_id: category_id,
                      brand_id: brand_id,
                      price: price,
                      detail: detail,
                      icon: file } }
      @product.reload
      expect(@product.name).to eq name
      expect(@product.category_id).to eq category_id
      expect(@product.brand_id).to eq brand_id
      expect(@product.price).to eq price
      expect(@product.detail).to eq detail
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end
  end

end
