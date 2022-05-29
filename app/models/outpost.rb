class Outpost < ApplicationRecord
  belongs_to :shipping_company
  has_many :stages
  has_many :deliveries, through: :stages

  validates_presence_of :name, :city_state, :category, unless: -> { standard }
  validate :uniqueness_of_outpost

  def uniqueness_of_outpost
    if Outpost.where(name: self.name, city_state: self.city_state, category: self.category, shipping_company: self.shipping_company).present?
      errors.add(:outpost_, I18n.t('activerecord.errors.models.outpost.not_unique'))
    end
  end
end
