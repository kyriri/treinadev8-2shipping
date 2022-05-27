class ShippingCompany < ApplicationRecord
  validates_uniqueness_of :name, :cnpj, conditions: -> { where.not(status: 'deleted') }
  validates_presence_of :name, :legal_name, :status, :cnpj, :email_domain, :billing_address
  validates_numericality_of :cnpj
  validates_numericality_of :cubic_weight_const, :min_fee, allow_nil: true
  validates_length_of :cnpj, { is: 14 }
  
  enum status: { deleted: 0, suspended: 2, in_registration: 5, active: 8 }

  has_many :shipping_rates
  has_many :delivery_times
  has_many :outposts

  def find_delivery_time(package)
    services = self.delivery_times
                   .where('max_distance_in_km >= ?', package.distance_in_km)
    if services.empty?
      nil
    else
      services.order(:max_distance_in_km)
              .first
              .delivery_time_in_buss_days
    end
  end

  def calculate_weight(package)
    return '' if package.weight_in_g.nil? || cubic_weight_const.nil?
    
    dead_weigth = package.weight_in_g.to_f / 1000
    cubic_weight = package.volume_in_m3 * cubic_weight_const
    [dead_weigth, cubic_weight].max
  end

  def find_rate(weight)
    services = self.shipping_rates
                   .where('max_weight_in_kg >= ?', weight)
    if services.empty?
      nil
    else
      services.order(:max_weight_in_kg)
              .first
              .cost_per_km_in_cents
    end
  end

  def calculate_fee(package, rate)
    return '' if rate.nil?
    fee = (rate * package.distance_in_km).to_f / 1000
    [fee, self.min_fee].max
  end

  def quote_for(service_order, code)
    delivery_time = find_delivery_time(service_order.package)
    weight = calculate_weight(service_order.package)
    rate = find_rate(weight)
    fee = calculate_fee(service_order.package, rate)

    if (rate.nil? || delivery_time.nil?)
      is_valid = false
      fee = ''
      delivery_time = ''
    else
      is_valid = true
    end

    Quote.create!(quote_group: code,
                  shipping_company: self,
                  service_order: service_order,
                  fee: fee,
                  delivery_time: delivery_time,
                  is_valid: is_valid,
                 )
  end
end
