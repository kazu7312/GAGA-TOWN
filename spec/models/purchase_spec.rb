require 'rails_helper'

RSpec.describe Purchase, type: :model do

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
    @purchase = Purchase.create!(user_id: @user.id,
                  destination_name: "yamada",
                  destination_address: "東京都八王子市",
                  destination_postal_code: "123-4567",
                  credit_number: "123456789012345",
                  total: 5,
                  size_id: @size.id,
                  product_name: @product.name,
                  category_name: @category.name,
                  brand_name: @brand.name,
                  price: 1500,
                  detail: "今冬の新作",
                  icon: "rails.png",
                  product_id: @product.id)
  end

  it "正しい購入履歴" do
    expect(@purchase).to be_valid
  end

  it "宛名が空白だとエラー" do
    @purchase.destination_name = nil
    expect(@purchase).not_to be_valid
  end

  it "宛名が256文字以上だとエラー" do
    @purchase.destination_name = "a" * 254
    expect(@purchase).to be_valid
    @purchase.destination_name = "a" * 255
    expect(@purchase).to be_valid
    @purchase.destination_name = "a" * 256
    expect(@purchase).not_to be_valid
  end

  it "不正な郵便番号が無効と認識されるか" do
    @purchase.destination_postal_code = ""
    expect(@purchase).not_to be_valid

    @purchase.destination_postal_code = "123-456"
    expect(@purchase).not_to be_valid
    @purchase.destination_postal_code = "123-4567"
    expect(@purchase).to be_valid
    @purchase.destination_postal_code = "123-45678"
    expect(@purchase).not_to be_valid

    invalid_destination_postal_codes = %w[12345678 123-45-6 -1234567 1-234567 12-34567
                      1234-567 12345-67 123456-7 1234567-]
    invalid_destination_postal_codes.each do |invalid_destination_postal_code|
      @purchase.destination_postal_code = invalid_destination_postal_code
      assert !@purchase.valid?, "#{invalid_destination_postal_code.inspect} should be invalid"
    end
  end

  it "送り先住所が空白でないこと" do
    @purchase.destination_address = ""
    expect(@purchase).not_to be_valid
  end

  it "送り先住所が255字以下であること" do
    @purchase.destination_address = "a" * 254
    expect(@purchase).to be_valid
    @purchase.destination_address = "a" * 255
    expect(@purchase).to be_valid
    @purchase.destination_address = "a" * 256
    expect(@purchase).not_to be_valid
  end

  it "クレジット番号が空白でないこと" do
    @purchase.credit_number = ""
    expect(@purchase).not_to be_valid
    @purchase.credit_number = nil
    expect(@purchase).not_to be_valid
  end

  it "クレジット番号が14字以上16字以下であること" do
    @purchase.credit_number = "1" * 13
    expect(@purchase).not_to be_valid
    @purchase.credit_number = "1" * 14
    expect(@purchase).to be_valid
    @purchase.credit_number = "1" * 15
    expect(@purchase).to be_valid
    @purchase.credit_number = "1" * 16
    expect(@purchase).to be_valid
    @purchase.credit_number = "1" * 17
    expect(@purchase).not_to be_valid
  end


  # it "details are destroyed if a related purchase is destroyed" do
  #   count = Detail.count
  #   @purchase.destroy
  #   expect(count).not_to eq Detail.count
  # end

end
