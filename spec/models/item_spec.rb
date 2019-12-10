require 'rails_helper'

RSpec.describe Item, type: :model do

  before do
    @category = Category.create!(name: "トップス")
    @brand    = Brand.create!(name: "BEAMS")
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
                  address: "東京都八王子市")
    @size     = Size.create!(name: "S")
    @cart     = Cart.create!(user_id: @user.id)
    @item     = Item.create!(product_id: @product.id,
                  size_id: @size.id,
                  quantity: 5,
                  cart_id: @cart.id)
  end

  it "正しいアイテム" do
    expect(@item).to be_valid
  end

  it "quantityが空白の場合エラー" do
    @item.quantity = nil
    expect(@item).not_to be_valid
  end

  it "quantityが0以下だとエラー" do
    @item.quantity = -1
    expect(@item).not_to be_valid
    @item.quantity = 0
    expect(@item).not_to be_valid
    @item.quantity = 1
    expect(@item).to be_valid
    @item.quantity = 2
    expect(@item).to be_valid
  end

  it "サイズIDが空白の場合エラー" do
    @item.size_id = nil
    expect(@item).not_to be_valid
  end
end
