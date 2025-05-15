# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

20.times do |i|
  user = User.create!(
    email: "user#{i}@example.com",
    password: "password",
    confirmed_at: Time.current,
  )
  user.create_user_info!(
    admin: false,
    balance: 50000.0,
    first_name: "John#{i}",
    last_name: "Doe",
    address: "123 Main St",
    birthdate: "1990-01-01",
  )

  if i < 10
    user.update(confirmed_at: nil)
  end
end

# Stock symbols and their current prices
STOCKS = {
  "IBM" => 120.75,
  "AAPL" => 185.25,
  "GOOGL" => 2850.00,
  "MSFT" => 330.50,
  "AMZN" => 125.75,
  "META" => 310.25,
  "NVDA" => 425.50,
  "TSLA" => 190.75,
  "JPM" => 155.25,
  "BAC" => 38.50,
}

# Create transactions for users 11-20
(11..20).each do |i|
  user = User.find_by(email: "user#{i}@example.com")
  next unless user

  5.times do
    stock = STOCKS.keys.sample
    action = %w[buy sell].sample
    price = STOCKS[stock] * (0.95 + rand(0.1))
    qty = rand(10..100)

    random_time = 1.year.ago + rand * (Time.current - 1.year.ago)

    user.user_info.transactions << Transaction.create(
      name: stock,
      action: action,
      date: random_time,
      price: price.round(2),
      qty: qty,
    )
  end
end

# Create Percy user with stocks
percyUser = User.create!(
  email: "percyavon1@example.com",
  password: "hello123",
  confirmed_at: Time.current,
)

percyUser.create_user_info!(
  admin: false,
  balance: 69420,
  first_name: "Percy",
  last_name: "Percyson",
  address: "123 Main St",
  birthdate: "2005-01-01",
)

[
  ["IBM", 120.75, 50],
  ["MSFT", 320.75, 150],
  ["AMZN", 125.40, 75],
  ["TSLA", 185.25, 200],
  ["GOOGL", 105.80, 125],
  ["NVDA", 450.20, 60],
  ["META", 350.50, 175],
  ["JPM", 150.75, 80],
  ["V", 250.45, 140],
  ["JNJ", 175.30, 95],
].each do |name, price, qty|
  stock = Stock.create(name: name, price: price, qty: qty)
  percyUser.user_info.stocks << stock
end

# Admin Users
percyAdmin = User.create!(
  email: "percyavon@example.com",
  password: "hello123",
  confirmed_at: Time.current,
)

percyAdmin.create_user_info!(
  admin: true,
  first_name: "Percy",
  last_name: "Admin",
  address: "123 Admin St",
  birthdate: "1980-01-01",
)

admin = User.create!(
  email: "admin@example.com",
  password: "password",
  confirmed_at: Time.current,
)

admin.create_user_info!(
  admin: true,
  first_name: "Admin",
  last_name: "User",
  address: "123 Admin St",
  birthdate: "1980-01-01",
)
