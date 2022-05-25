class ServiceOrder < ApplicationRecord
  belongs_to :package
  enum status: { canceled: 0, unassigned: 1, rejected: 3, pending: 5, accepted: 7, delivered: 9 }

  def get_quotes
    active_companies = ShippingCompany.where(status: 'active')
    if active_companies.empty?
      []
    else
      active_companies.map do |company|
        company.quote_for(self.package)
      end
    end
  end

  def select_carriers_with_best(criteria, quotes)
    return 'Unable to choose best quote from an empty list' if quotes.empty?

    best_value = quotes.map { |quote| quote.values_at(criteria) }
                       .flatten
                       .min
    quotes.select { |quote| quote.has_value? best_value }
  end
end
