require 'rails_helper'

RSpec.describe "items#create", type: :request do


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
      @user1    = User.create!(
                    name:  "Example User",
                    email: "example1@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: false )

      @cart     = Cart.create!(user_id: @user.id)

    end

  describe "create" do

    it "アイテムが正しく生成される場合" do
      log_in_as(@user)
      get "/products/#{@product.id}"
      count = Item.count
      post item_create_path, params: {
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   5,
        cart_id:    @cart.id
        }
      expect(count+1).to eq Item.count
      follow_redirect!
      expect(response).to render_template "carts/show"
    end

    it "購入数が入力されていなかった場合" do
      log_in_as(@user)
      get "/products/#{@product.id}"
      count = Item.count
      post item_create_path, params: {
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   0,
        cart_id:    @cart.id
      }
      expect(count).to eq Item.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

    it "購入数が負数だった場合" do
      log_in_as(@user)
      get "/products/#{@product.id}"
      count = Item.count
      post item_create_path, params: {
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   -1,
        cart_id:    @cart.id
      }
      expect(count).to eq Item.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

    it "購入する商品のproduct_idと同じproduct_idの商品がitem_table入っており、かつそのsize_idもitem_tableの商品と同じ場合" do
      @item = Item.create!(
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   5,
        cart_id:    @cart.id
      )
      log_in_as(@user)
      get "/products/#{@product.id}"
      count    = Item.count
      quantity = Item.first.quantity
      post item_create_path, params: {
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   5,
        cart_id:    @cart.id
        }
      expect(count).to eq Item.count
      expect(quantity+5).to eq Item.first.quantity
      follow_redirect!
      expect(response).to render_template "carts/show"
    end

    it "購入する商品のproduct_idと同じproduct_idの商品がitem_table入っており、かつそのsize_idはitem_tableの商品と異なる場合" do
      @item = Item.create!(
        product_id: @product.id,
        size_id:    @size.id,
        quantity:   5,
        cart_id:    @cart.id
      )
      log_in_as(@user)
      get "/products/#{@product.id}"
      count    = Item.count
      quantity = Item.first.quantity
      post item_create_path, params: {
        product_id: @product.id,
        size_id:    @size1.id,
        quantity:   8,
        cart_id:    @cart.id
        }
      expect(count+1).to eq Item.count
      expect(quantity+3).to eq Item.order("id DESC").first.quantity
      follow_redirect!
      expect(response).to render_template "carts/show"
    end

  end

  describe "add_quantity" do

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
      expect(flash[:danger].nil?).to be_falsey
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
      expect(flash[:danger].nil?).to be_falsey
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
