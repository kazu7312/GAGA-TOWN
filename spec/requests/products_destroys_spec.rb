require 'rails_helper'

RSpec.describe "ProductsDestroys", type: :request do
  describe "GET /products_destroys" do
    it "works! (now write some real specs)" do
      get products_destroys_path
      expect(response).to have_http_status(200)
    end
  end
end
