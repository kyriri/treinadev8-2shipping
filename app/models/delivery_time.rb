class DeliveryTime < ApplicationRecord
  validates_uniqueness_of :max_distance_in_km, scope: :shipping_company

  belongs_to :shipping_company
end
