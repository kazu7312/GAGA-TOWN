require 'rails_helper'

RSpec.describe "products#destroy", type: :request do

  include SessionsHelper

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
      @user     = User.create!(name:  "Example User",
                    email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: true )
      @cart     = Cart.create!(user_id: @user.id)
      @item     = Item.new
    end

  describe "create" do

    # it "ログインが済んでいない場合、ログインページへリダイレクト" do
    #   get new_product_path
    #   follow_redirect!
    #   assert_select "div.alert"
    #   expect(response).to render_template "sessions/new"
    # end

    it "アイテムが正しく生成される場合" do
      log_in_as(@user)
      count = Item.count
      post item_create_path(@item), params: { item: {
        #id:         @item.id,
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   5,
        cart_id:    @cart.id
        }
      }
      expect(count+params[:quantity]).to eq Item.count
      follow_redirect!
      expect(response).to render_template "carts/show"
    end


    it "購入数が不正な場合" do
      log_in_as(@user)
      counto = Order.count
      countd = Detail.count
      post "/cart", params: { product_id: @product.id, detail: { amount: 100001 } }
      expect(counto).to eq Order.count
      expect(countd).to eq Detail.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(any_carts?).to be_falsey
      expect(response).to render_template "products/show"
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

    it "不正なユーザーでアクセスした場合、homeへリダイレクト" do
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
      expect(count).to eq Product.count - 1
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/new"
    end

  end

end
