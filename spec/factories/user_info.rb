FactoryBot.define do
  factory :user_info do
    admin { false }
    balance { 50000 }
  end

  factory :stock do
    name { "IBM" }
    price { 350 }
    qty { 25 }
  end
end
