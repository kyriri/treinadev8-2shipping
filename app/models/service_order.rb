class ServiceOrder < ApplicationRecord
  belongs_to :package
  enum status: { canceled: 0, unassigned: 1, rejected: 3, pending: 5, accepted: 7, delivered: 9 }

  def get_quotes
    ShippingCompany.where(status: 'active').map do |company|
      company.calculate_quote(self.package.id)
      # [ { company_id: 1, package_id: 32, fee: 15.50, delivery_time: 2 }, 
      #   { company_id: 2, package_id: 32, fee: 7.23, delivery_time: 5 }, 
      # ]
    end
  end

  # quotes = self.get_quotes

  def select_carriers_with_best(criteria, quotes)
    return 'Unable to choose best quote from an empty array' if quotes.empty?

    best_value = quotes.map { |quote| quote.values_at(criteria) }
                       .flatten
                       .min
    quotes.select { |quote| quote.has_value? best_value }
  end
end
