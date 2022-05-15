class ShippingCompany < ApplicationRecord
  enum status: { suspended: 2, active: 8 }
end
