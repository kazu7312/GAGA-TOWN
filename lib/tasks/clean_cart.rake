namespace :clean_cart do
  desc "３日以前に作られたカートを削除する"

  task clean_cart: :environment do
    carts = Cart.where("created_at <= ?", Time.zone.now - 3.days)
    if carts
      carts.each do |cart|
      cart.destroy
    end
    puts "古いカートを削除しました"
    end
  end

end
