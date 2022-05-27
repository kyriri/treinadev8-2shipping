class Delivery < ApplicationRecord
  belongs_to :service_order
  has_many :stages
  has_many :outposts, through: :stages
end
