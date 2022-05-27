class Step < ApplicationRecord
  belongs_to :delivery
  belongs_to :outposts
end
