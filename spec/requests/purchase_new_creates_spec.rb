require 'rails_helper'

RSpec.describe "商品購入周り", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @brand    = Brand.create!(name: "BEAMS")
      @size     = Size.create!(name: "S")
      @size1    = Size.create!(name: "M")
      @product  = Product.create!(
                    name: "トップス S",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "hoge"
                  )
      @product1 = Product.create!(
                    name: "トップス M",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png"
                  )
      @user     = User.create!(
                    name: "Example User",
                    email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password",
                    postal_code: "123-4567",
                    address: "東京都八王子市",
                    admin: true
                  )
      @cart     = Cart.create!(user_id: @user.id)
      @stock   = Stock.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    stock:      10
                  )
      @stock1  = Stock.create!(
                    product_id: @product.id,
                    size_id:    @size1.id,
                    stock:      2000
                  )
      @file = fixture_file_upload("1057374906.g_400-w_g.jpg", true)
    end

  describe "new" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      get new_purchase_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "購入確認ページへ遷移" do
      log_in_as(@user)
      get new_purchase_path
      expect(response).to have_http_status :success
      expect(response).to render_template "purchases/new"
    end


  end

  describe "create" do

    it "アイテムが正しく購入される場合" do
      log_in_as(@user)
      @item     = Item.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    quantity:   5,
                    cart_id:    @cart.id
                  )
      get new_product_path
      count = Purchase.count
      stock = Stock.first.stock
      post "/purchases", params: { purchase: {
        user_id:                  @cart.user_id,
        destination_name:         @user.name,
        destination_address:      @user.address,
        destination_postal_code:  @user.postal_code,
        credit_number:            "123456789012345",
        product_id:               @item.product_id,
        size_id:                  @item.size_id,
        total:                    @item.quantity,
        product_name:             @product.name,
        category_name:            @category.name,
        brand_name:               @brand.name,
        price:                    @product.price,
        detail:                   @product.detail,
        icon:                     @product.icon
        }
      }
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template root_path
      expect(count+1).to eq Purchase.count
      expect(stock-5).to eq Stock.first.stock
    end

    it "アイテム購入に失敗する場合" do
      log_in_as(@user)
      @item     = Item.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    quantity:   100,
                    cart_id:    @cart.id
                  )
      get new_product_path
      count = Purchase.count
      stock = Stock.first.stock
      post "/purchases", params: { purchase: {
        user_id:                  @cart.user_id,
        destination_name:         @user.name,
        destination_address:      @user.address,
        destination_postal_code:  @user.postal_code,
        credit_number:            "123456789012345",
        product_id:               @item.product_id,
        size_id:                  @item.size_id,
        total:                    @item.quantity,
        product_name:             @product.name,
        category_name:            @category.name,
        brand_name:               @brand.name,
        price:                    @product.price,
        detail:                   @product.detail,
        icon:                     @product.icon
        }
      }
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "purchases/new"
      expect(count).to eq Purchase.count
      expect(stock).to eq Stock.first.stock
    end

    it "カートに商品が入っていない場合" do
      log_in_as(@user)
      get new_product_path
      @item = nil
      count = Purchase.count
      stock = Stock.first.stock
      post "/purchases", params: {
        user_id:                  @cart.user_id,
        destination_name:         @user.name,
        destination_address:      @user.address,
        destination_postal_code:  @user.postal_code,
        credit_number:            "123456789012345",
        }
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template root_path
      expect(count).to eq Purchase.count
      expect(stock).to eq Stock.first.stock
    end
  end


  describe "index" do

    it "カートに商品が入っていない場合" do
      log_in_as(@user)
      @purchase = Purchase.create!(
        user_id:                  @user.id,
        destination_name:         @user.name,
        destination_address:      @user.address,
        destination_postal_code:  @user.postal_code,
        credit_number:            "123456789012345",
        product_id:               @product.id,
        size_id:                  @size.id,
        total:                    5,
        product_name:             @product.name,
        category_name:            @category.name,
        brand_name:               @brand.name,
        price:                    @product.price,
        detail:                   @product.detail,
        icon:                     @product.icon
      )
      get purchases_path
      expect(response).to have_http_status :success
      expect(response).to render_template "purchases/index"
    end
  end
end
