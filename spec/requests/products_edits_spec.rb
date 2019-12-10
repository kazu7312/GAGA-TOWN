require 'rails_helper'

RSpec.describe "ProductsEdits", type: :request do
  describe "GET /products_edits" do
    it "works! (now write some real specs)" do
      get products_edits_path
      expect(response).to have_http_status(200)
    end
  end
end
