require 'rails_helper'

RSpec.describe "ProductsUpdates", type: :request do
  describe "GET /products_updates" do
    it "works! (now write some real specs)" do
      get products_updates_path
      expect(response).to have_http_status(200)
    end
  end
end
