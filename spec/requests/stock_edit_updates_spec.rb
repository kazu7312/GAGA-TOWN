require 'rails_helper'

RSpec.describe "商品追加周り", type: :request do

    before do
      @category = Category.create!(name: "トップス")
      @brand    = Brand.create!(name: "BEAMS")
      @size     = Size.create!(name: "S")
      @product  = Product.create!(
                    name: "トップス S",
                    category_id: @category.id,
                    brand_id: @brand.id,
                    price: 1500,
                    detail: "今冬の新作",
                    icon: "rails.png")
      @user     = User.create!(
                    name:  "Example User",
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
      @file = fixture_file_upload("1057374906.g_400-w_g.jpg", true)
      @stock   = Stock.create!(
                    product_id: @product.id,
                    size_id:    @size.id,
                    stock:      1000
                  )

    end

  describe "new" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      get "/stocks/#{@product.id}/edit"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end


    it "管理者ユーザーでない場合、homeへリダイレクト" do
      log_in_as(@user1)
      get "/stocks/#{@product.id}/edit"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "管理者ユーザーでログイン時、ストック編集ページへ" do
      log_in_as(@user)
      get "/stocks/#{@product.id}/edit"
      expect(response).to have_http_status :success
      expect(response).to render_template "stocks/edit"
    end

  end

  describe "create" do

    it "ログインが済んでいない場合、ログインページへリダイレクト" do
      stock = Stock.first.stock
      patch "/stocks/#{@product.id}", params: { stock: {
                      product_id: @product.id,
                      size_id:    @size.id,
                      add_stock:      1000,
                      }
                    }
      expect(stock).to eq Stock.first.stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "管理者でないユーザーでアクセスした場合、homeへリダイレクト" do
      log_in_as(@user1)
      stock = Stock.first.stock
      patch "/stocks/#{@product.id}", params: { stock: {
                      product_id: @product.id,
                      size_id:    @size.id,
                      add_stock:      1000,
                      }
                    }
      expect(stock).to eq Stock.first.stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "ストック変更に失敗した場合、homeへリダイレクト" do
      log_in_as(@user)
      get "/stocks/#{@product.id}/edit"
      stock = Stock.first.stock
      patch "/stocks/#{@product.id}", params: {
                      product_id: @product.id,
                      size_id:    @size.id,
                      add_stock:  -50000,
                    }
      expect(stock).to eq Stock.first.stock
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template root_path
    end

    it "管理者で新規ストック追加時、正しくストック追加される場合" do
      log_in_as(@user)
      get "/stocks/#{@product.id}/edit"
      stock = Stock.first.stock
      patch "/stocks/#{@product.id}", params: {
                      product_id: @product.id,
                      size_id:    @size.id,
                      add_stock:      1000,
                    }
      expect(stock+1000).to eq Stock.first.stock
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template root_path
    end

  end

end
