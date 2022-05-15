class ShippingCompany < ApplicationRecord
  validates :name, :legal_name, :status, :cnpj, :email_domain, :billing_address, 
            presence: true
  validates :name, :cnpj, uniqueness: true
  validates :cnpj, length: { is: 14 }
  enum status: { suspended: 2, in_registration: 5, active: 8 }
end
