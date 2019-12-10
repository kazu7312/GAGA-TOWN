require 'rails_helper'

RSpec.describe "carts#show", type: :request do

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
      @product1 = Product.create!(name: "トップス M",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の一番人気",
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
                    admin: true )

      @cart = Cart.create!(user_id: @user.id)
      @current_cart = @cart

    end

  describe "show" do


    # it "should redirect when not logged in" do
    #   get "/carts/#{@cart.id}"
    #   follow_redirect!
    #   assert_select "div.alert"
    #   expect(response).to render_template "sessions/new"
    # end

    it "invalid access when logged in with wrong user" do
      log_in_as(@user1)
      get "/cart/#{@cart.id}"
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access without carts" do
      log_in_as(@user)
      get "/cart/#{@cart.id}"
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "valid access with carts" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      @cart = @user.carts.last
      @cart.reload
      get "/cart/#{@cart.id}"
      expect(response).to have_http_status :success
      expect(response).to render_template "cart/show"
    end

    it "invalid access if the cart is expired" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      @cart = @user.carts.last
      count = cart.count

      @cart.update_attribute(:cart_created_at, Time.zone.now - 29.minutes)
      get "/cart/#{@cart.id}"
      expect(count).to eq cart.count
      expect(response).to have_http_status :success
      expect(response).to render_template "cart/show"

      @cart.update_attribute(:cart_created_at, Time.zone.now - 30.minutes)
      get "/cart/#{@cart.id}"
      expect(count).not_to eq cart.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"

      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      @cart = @user.carts.last
      count = cart.count
      @cart.update_attribute(:cart_created_at, Time.zone.now - 31.minutes)
      get "/cart/#{@cart.id}"
      expect(count).not_to eq cart.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "cart_products properly works" do
      @detail = Detail.create!(cart_id: @cart.id, product_id: @product.id, amount: 10)
      @detail1 = Detail.create!(cart_id: @cart.id, product_id: @product.id, amount: 10)
      p = [Product.find(@cart.details.first.product_id).id, Product.find(@cart.details.last.product_id).id]
      expect(cart_products(@cart)).to eq p
    end

  end
end
