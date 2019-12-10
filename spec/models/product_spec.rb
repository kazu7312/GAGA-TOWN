require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "プロダクトモデルの有効性テスト" do

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
      @stock    = Stock.new(product_id: @product.id,
                   size_id: @size.id,
                   stock: 2000)
    end

    it "正しいプロダクトの認識" do
      expect(@product).to be_valid
    end

    it "商品名が空白にならないこと" do
      @product.name = ""
      expect(@product).not_to be_valid
    end

    it "商品名の長さが255文字以下であること" do
      @product.name = "a" * 254
      expect(@product).to be_valid
      @product.name = "a" * 255
      expect(@product).to be_valid
      @product.name = "a" * 256
      expect(@product).not_to be_valid
    end

    it "ブランドIDが空白だと無効であること" do
      @product.brand_id = nil
      expect(@product).not_to be_valid
    end

    it "カテゴリIDが空白だと無効であること" do
      @product.category_id = nil
      expect(@product).not_to be_valid
    end

    it "priceが空白だと無効であること" do
      @product.price = nil
      expect(@product).not_to be_valid
    end

    it "priceが負数だと無効であること" do
      @product.price = -1
      expect(@product).not_to be_valid
      @product.price = 0
      expect(@product).to be_valid
      @product.price = 1
      expect(@product).to be_valid
    end

    it "商品詳細が空白だと無効であること" do
      @product.detail = ""
      expect(@product).not_to be_valid
    end

    it "商品詳細の長さが501字以上だと無効であること" do
      @product.detail = "a" * 499
      expect(@product).to be_valid
      @product.detail = "a" * 500
      expect(@product).to be_valid
      @product.detail = "a" * 501
      expect(@product).not_to be_valid
    end

  end

end
