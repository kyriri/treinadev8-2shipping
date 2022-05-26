class Quote < ApplicationRecord
  belongs_to :shipping_company
  belongs_to :package
end
