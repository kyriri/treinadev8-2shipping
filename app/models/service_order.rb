class ServiceOrder < ApplicationRecord
  enum status: { unassigned: 0, rejected: 2, pending: 4, accepted: 6, delivered: 8 }
end
