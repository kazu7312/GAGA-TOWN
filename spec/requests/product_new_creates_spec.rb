require 'rails_helper'

RSpec.describe "商品追加周り", type: :request do

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
    end

  describe "new" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      get new_product_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end


    it "管理者ユーザーでない場合、homeへリダイレクト" do
      log_in_as(@user1)
      get new_product_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "管理者ユーザーでログイン" do
      log_in_as(@user)
      get new_product_path
      expect(response).to have_http_status :success
      expect(response).to render_template "products/new"
    end

  end

  describe "create" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      count = Product.count
      post products_path, params: { product: { name: "トップス M",
                      category_id: @category.id,
                      brand_id: @brand.id,
                      price: 1500,
                      detail: "今冬の新作",
                      icon: @file } }
      expect(count).to eq Product.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "管理者でないユーザーでアクセスした場合、homeへリダイレクト" do
      log_in_as(@user1)
      count = Product.count
      post products_path, params: { product: { name: "トップス M",
                      category_id: @category.id,
                      brand_id: @brand.id,
                      price: 1500,
                      detail: "今冬の一番人気",
                      icon: @file } }
      expect(count).to eq Product.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "管理者で商品追加時、誤った入力がされた場合、エラーメッセージと共にproduct#newへ遷移" do
      log_in_as(@user)
      count = Product.count
      post products_path, params: { product: { name: "トップス S",
                      category_id: @category.id,
                      brand_id: @brand.id,
                      price: 100,
                      detail: "",
                      picture: @file } }
      expect(count).to eq Product.count
      assert_select "div#error_explanation"
      expect(response).to render_template "products/new"
    end

    it "管理者で商品追加時、正しく商品追加される場合" do
      log_in_as(@user)
      count = Product.count
      post products_path, params: { product: { name: "トップス M",
                      category_id: @category.id,
                      brand_id: @brand.id,
                      price: 1500,
                      detail: "今冬の一番人気",
                      icon: @file } }
      expect(count+1).to eq Product.count
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/new"
    end

  end

end
