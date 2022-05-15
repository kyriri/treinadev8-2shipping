class ShippingCompany < ApplicationRecord
  enum status: { suspended: 2, in_registration: 5, active: 8 }
end
