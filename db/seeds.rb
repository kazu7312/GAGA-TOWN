User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             postal_code: "123-4567",
             address: "tokyo-03",
             password:              "password",
             password_confirmation: "password",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  postal_code = "123-4567"
  address = "tokyo-#{n+1}"
  User.create!(name:  name,
               email: email,
               postal_code: postal_code,
               address: address,
               password:              "password",
               password_confirmation: "password")
end

100.times do |n|
  name  = Faker::Name.name
  category_id = n%10+1
  brand_id = n%10+1
  price = (n+1)*1000
  detail = "No, #{n}"
  icon = "icon #{n}"
  Product.create!(name:  name,
                  category_id: category_id,
                  brand_id: brand_id,
                  price: price,
                  detail: detail,
                  icon: icon)
end

100.times do |n|
  product_id  = n+1
  size_id = n%6+1
  count = n*100
  Stock.create!(product_id: product_id,
                size_id: size_id,
                count: count)
end

100.times do |n|
  product_id  = n+1
  size_id = n%6+1
  quantity = n%5+1
  Item.create!(product_id: product_id,
               size_id: size_id,
               quantity: quantity)
end


100.times do |n|
  user_id  = n+1
  item_id = n+1
  Cart.create!(user_id: user_id,
               item_id: item_id)
end


100.times do |n|
  user_id  = n+1
  item_id = n+1
  destination_name = "name-#{n}"
  destination_address = "address-#{n}"
  destination_postal_code = "123-4567"
  credit_number = 12233345
  Purchase.create!(user_id: user_id,
                   item_id: item_id,
                   destination_name: destination_name,
                   destination_address: destination_address,
                   destination_postal_code: destination_postal_code,
                   credit_number: credit_number)
end

100.times do |n|
  user_id  = n+1
  product_id = n+1
  Favorite.create!(product_id: product_id,
                   user_id: user_id)
end
