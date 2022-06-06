class ShippingRate < ApplicationRecord
  validates_presence_of :max_weight_in_kg, :cost_per_km_in_cents
  validates_uniqueness_of :max_weight_in_kg, scope: :shipping_company

  belongs_to :shipping_company
end
