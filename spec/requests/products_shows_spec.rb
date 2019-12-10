require 'rails_helper'

RSpec.describe "ProductsShows", type: :request do
  describe "GET /products_shows" do
    it "works! (now write some real specs)" do
      get products_shows_path
      expect(response).to have_http_status(200)
    end
  end
end
