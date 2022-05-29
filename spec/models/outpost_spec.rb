require 'rails_helper'

RSpec.describe Outpost, type: :model do
  xdescribe '#valid?' do
  # TODO I need custom validations to implement this
    it 'is false when outposts are repeated' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      Outpost.create!(shipping_company: sc1, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de distribuição')
      new_outpost = Outpost.new(shipping_company: sc1, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de distribuição')
      
      new_outpost.valid?

      expect(new_outpost.errors.full_messages).to include('já')
    end
    
    it 'is true if the repeated outpost was soft deleted' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      Outpost.create!(deleted: true, shipping_company: sc1, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de distribuição')
      new_outpost = Outpost.new(shipping_company: sc1, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de distribuição')
      
      response = new_outpost.valid?

      expect(response).to be true
    end
  end
end
