class ShippingRate < ApplicationRecord
  validates_uniqueness_of :max_weight_in_kg, scope: :shipping_company

  belongs_to :shipping_company
end
