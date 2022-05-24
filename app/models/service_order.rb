class ServiceOrder < ApplicationRecord
  belongs_to :package
  enum status: { canceled: 0, unassigned: 1, rejected: 3, pending: 5, accepted: 7, delivered: 9 }

def select_carriers_with_best(criteria, quotes)
    best_value = quotes.map { |quote| quote.values_at(criteria) }
                       .flatten
                       .min
    quotes.select { |quote| quote.has_value? best_value }
  end
end
