require 'rails_helper'

RSpec.describe Stock, type: :model do

  before do
    @category = Category.create!(name: "トップス")
    @brand    = Brand.create!(name: "BEAMS")
    @product  = Product.create!(name: "トップス S",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png")
    @size     = Size.create!(name: "S")
    @stock    = Stock.new(product_id: @product.id,
                 size_id: @size.id,
                 stock: 2000)
  end

  it "正しいストックの認識" do
    expect(@stock).to be_valid
  end

  it "ストックが空白にならないこと" do
    @stock.stock = nil
    expect(@stock).not_to be_valid
  end

  it "ストックが負数だとエラー" do
    @stock.stock = -1
    expect(@stock).not_to be_valid
    @stock.stock = 0
    expect(@stock).to be_valid
    @stock.stock = 1
    expect(@stock).to be_valid
  end


end
