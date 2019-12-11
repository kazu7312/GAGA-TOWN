require 'rails_helper'

RSpec.describe "products#destroy", type: :request do

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
                    admin: true)
      @cart     = Cart.create!(user_id: @user.id)
      @item     = Item.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    quantity:   5,
                    cart_id:    @cart.id
                  )
    end
  describe "add_quantity" do

    it "1つ追加される場合" do
      log_in_as(@user)
      get "/carts/#{@cart.id}"
      quantity = Item.first.quantity
      post item_add_path(id: @item.id)
      expect(quantity+1).to eq Item.first.quantity
      follow_redirect!
      expect(response).to render_template "carts/show"
    end
  end

  describe "reduce_quantity" do

    it "1つ削減される場合" do
      log_in_as(@user)
      get "/carts/#{@cart.id}"
      quantity = Item.first.quantity
      post item_reduce_path(id: @item.id)
      expect(quantity-1).to eq Item.first.quantity
      follow_redirect!
      expect(response).to render_template "carts/show"
    end
  end

  describe "destroy" do

    it "商品が削除される場合" do
      log_in_as(@user)
      get "/carts/#{@cart.id}"
      count = Item.count
      delete item_path(@item)
      expect(count-1).to eq Item.count
      follow_redirect!
      expect(response).to render_template "carts/show"
    end
  end
end
