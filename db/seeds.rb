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
