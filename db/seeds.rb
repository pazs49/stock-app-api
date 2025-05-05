# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

20.times do |i|
  user = User.create!(
    email: "user#{i}@example.com",
    password: "password",
    confirmed_at: Time.current,
  )
  user.create_user_info!(admin: false, balance: 50000.0)

  if i < 10
    user.update(confirmed_at: nil)
  end
end

##########
percyUser = User.create!(
  email: "percyavon1@example.com",
  password: "hello123",
  confirmed_at: Time.current,
)

percyUser.create_user_info!(admin: false, balance: 69420)

stock2 = Stock.create(name: "IBM", price: 120.75, qty: 50)
stock3 = Stock.create(name: "MSFT", price: 320.75, qty: 150)
stock4 = Stock.create(name: "AMZN", price: 125.40, qty: 75)
stock5 = Stock.create(name: "TSLA", price: 185.25, qty: 200)
stock6 = Stock.create(name: "GOOGL", price: 105.80, qty: 125)
stock7 = Stock.create(name: "NVDA", price: 450.20, qty: 60)
stock8 = Stock.create(name: "META", price: 350.50, qty: 175)
stock9 = Stock.create(name: "JPM", price: 150.75, qty: 80)
stock10 = Stock.create(name: "V", price: 250.45, qty: 140)
stock11 = Stock.create(name: "JNJ", price: 175.30, qty: 95)

percyUser.user_info.stocks << stock2
percyUser.user_info.stocks << stock3
percyUser.user_info.stocks << stock4
percyUser.user_info.stocks << stock5
percyUser.user_info.stocks << stock6
percyUser.user_info.stocks << stock7
percyUser.user_info.stocks << stock8
percyUser.user_info.stocks << stock9
percyUser.user_info.stocks << stock10
percyUser.user_info.stocks << stock11

##########
percyAdmin = User.create!(
  email: "percyavon@example.com",
  password: "hello123",
  confirmed_at: Time.current,
)

percyAdmin.create_user_info!(admin: true)
###########
admin = User.create!(
  email: "admin@example.com",
  password: "password",
  confirmed_at: Time.current,
)

admin.create_user_info!(admin: true)
###########
