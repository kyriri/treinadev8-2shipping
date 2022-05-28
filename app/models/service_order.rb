class ServiceOrder < ApplicationRecord
  enum status: { canceled: 0, unassigned: 1, rejected: 3, pending: 5, accepted: 7, delivered: 9 }
  
  belongs_to :package
  belongs_to :shipping_company, optional: true
  has_many :quotes
  has_one :delivery

  def get_quotes
    active_companies = ShippingCompany.where(status: 'active')
    return 'no active companies' if active_companies.empty?
    quote_group = get_code 
    active_companies.map do |company|
      company.quote_for(self, quote_group)
    end
  end

  def get_code # TODO test this method
    "#{SecureRandom.alphanumeric(3).upcase}-#{SecureRandom.alphanumeric(3).upcase}"
  end


  def create_delivery # TODO test this
    code = ('a'..'z').to_a.shuffle[0..1].join.upcase + (SecureRandom.random_number * 10**8).to_i.to_s + 'BR'
    Delivery.create!(service_order: self, tracking_code: code)
  end

  def select_carriers_with_best(criteria, quotes)
    return 'Unable to choose best quote from an empty list' if quotes.empty?

    best_value = quotes.map { |quote| quote.values_at(criteria) }
                       .flatten
                       .min
    quotes.select { |quote| quote.has_value? best_value }
  end
end
