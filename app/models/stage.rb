class Stage < ApplicationRecord
  belongs_to :delivery
  belongs_to :outpost

  before_create :fill_when

  def fill_when
    self.when = Time.now if self.when.nil? 
  end
end
