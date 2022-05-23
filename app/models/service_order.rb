class ServiceOrder < ApplicationRecord
  belongs_to :package
  enum status: { canceled: 0, unassigned: 1, rejected: 3, pending: 5, accepted: 7, delivered: 9 }
end
