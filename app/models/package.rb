# Package is the object this system would receive from outside
class Package < ApplicationRecord
  before_create :populate_package_attr
  
  private

  def populate_package_attr
    self.width_in_cm = 32 if width_in_cm.nil?
    self.height_in_cm = 5 if height_in_cm.nil?
    self.length_in_cm = 24 if length_in_cm.nil?
    self.volume_in_m3 = 0.00384 if volume_in_m3.nil?
    self.weight_in_g = 1543 if weight_in_g.nil?
    self.distance_in_km = 78 if distance_in_km.nil?
    self.pickup_address = 'Galpão XPTO - Av. Brasil 2.345, Rio de Janeiro - RJ' if pickup_address.nil?
    self.delivery_address = 'Av. Getúlio Vargas 354, Rio de Janeiro - RJ' if delivery_address.nil?
    self.delivery_recipient_name = 'Jane Doe' if delivery_recipient_name.nil?
    self.delivery_recipient_phone = '(21) 9 5555-5555' if delivery_recipient_phone.nil?
  end
end
