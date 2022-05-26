class Quote < ApplicationRecord
  belongs_to :shipping_company
  belongs_to :service_order
end
