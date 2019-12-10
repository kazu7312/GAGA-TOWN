require 'rails_helper'

RSpec.describe "商品追加周り", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @brand    = Brand.create!(name: "BEAMS")
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
      @stock = Stock.create!(product_id: @product.id,
                    stock: 100000,
                    size_id: @size.id)
      # @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
      # @order1 = Order.create(user_id: @user1.id, ordered_at: Time.zone.now)
      # @file = fixture_file_upload("612ccaeb6b1f0d25324f9a290f31d054_s.jpg", true)
    end

  describe "new" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      get new_product_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end


    it "不正な入力の場合、homeへリダイレクト" do
      log_in_as(@user1)
      get new_product_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "正しい管理者ユーザーでログイン" do
      log_in_as(@user)
      get new_product_path
      expect(response).to have_http_status :success
      expect(response).to render_template "products/new"
    end

  end

  describe "create" do

    it "should redirect when not logged in" do
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: @file } }
      expect(count).to eq Product.count
      expect(counts).to eq Stock.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: @file } }
      expect(count).to eq Product.count
      expect(counts).to eq Stock.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "product addition failure with invalid information by logged in admin user" do
      log_in_as(@user)
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat S",
                      gender_id: nil,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1000000000,
                      abstract: "",
                      picture: @file } }
      expect(count).to eq Product.count
      expect(counts).to eq Stock.count
      assert_select "div#error_explanation"
      expect(response).to render_template "products/new"
    end

    it "product addition success with valid information by logged in admin user" do
      log_in_as(@user)
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: @file } }
      expect(count).not_to eq Product.count
      expect(counts).not_to eq Stock.count
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

  end

end
