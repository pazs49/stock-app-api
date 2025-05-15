class UserInfo < ApplicationRecord
  belongs_to :user
  has_many :stocks, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :first_name, :last_name, :birthdate, :address, presence: true
end
