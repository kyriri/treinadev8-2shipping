class ShippingCompany < ApplicationRecord
  validates_uniqueness_of :name, :cnpj, conditions: -> { where.not(status: 'deleted') }
  validates_presence_of :name, :legal_name, :status, :cnpj, :email_domain, :billing_address
  validates_numericality_of :cnpj
  validates_numericality_of :cubic_weight_const, :min_fee, allow_nil: true
  validates_length_of :cnpj, { is: 14 }
  
  enum status: { deleted: 0, suspended: 2, in_registration: 5, active: 8 }

  has_many :shipping_rates
  has_many :delivery_times

  def find_delivery_time(package)
    services = self.delivery_times
                   .where('max_distance_in_km >= ?', package.distance_in_km)
    if services.empty?
      'Delivery outside range'
    else
      services.order(:max_distance_in_km)
              .first
              .delivery_time_in_buss_days
    end
  end
end
