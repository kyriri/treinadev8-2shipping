class Outpost < ApplicationRecord
  belongs_to :shipping_company
  has_many :stages
  has_many :deliveries, through: :stages
end
