class Transaction < ApplicationRecord
  belongs_to :user_info

  validates :action, presence: true, inclusion: { in: ['buy', 'sell'] }
  validates :date, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :qty, presence: true, numericality: { greater_than: 0 }
end


