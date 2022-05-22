class ServiceOrder < ApplicationRecord
  belongs_to :package
  enum status: { unassigned: 0, rejected: 2, pending: 4, accepted: 6, delivered: 8 }
end
