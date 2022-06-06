require 'rails_helper'

RSpec.describe ShippingRate, type: :model do
  describe '#valid' do
    context 'should be false if' do
      it 'weight is blank' do
        sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 300, min_fee: 5)
        rate = ShippingRate.new(max_weight_in_kg: '', cost_per_km_in_cents: 99, shipping_company: sc)
        
        rate.valid?

        expect(rate.errors.full_messages).to include('peso máximo não pode ficar em branco')
      end

      it 'rate is blank' do
        sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 300, min_fee: 5)
        rate = ShippingRate.new(max_weight_in_kg: '1', cost_per_km_in_cents: '', shipping_company: sc)
        
        rate.valid?

        expect(rate.errors.full_messages).to include('custo por km não pode ficar em branco')
      end

      it 'weight was already in database' do
        sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 300, min_fee: 5)
        ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 60, shipping_company: sc1)
        s_r = ShippingRate.new(max_weight_in_kg: 1, cost_per_km_in_cents: 99, shipping_company: sc1)

        s_r.valid?

        expect(s_r.errors.full_messages).to include('peso máximo já cadastrado')
      end

      it 'no shipping company is associated to rate' do
        s_r = ShippingRate.new(max_weight_in_kg: 1, cost_per_km_in_cents: 99)

        s_r.valid?
        
        expect(s_r.errors.full_messages).to include('transportadora precisa constar na informação da taxa')
      end
    end
    
    context 'should be true if' do
      it 'the rate was already on database, but for another company' do
        sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 300, min_fee: 5)
        sc2 = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', min_fee: 10)
        ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 60, shipping_company: sc1)
        s_r = ShippingRate.new(max_weight_in_kg: 1, cost_per_km_in_cents: 99, shipping_company: sc2)
        
        response = s_r.valid?

        expect(response).to be true
        expect(s_r.errors.full_messages).not_to include('peso máximo já cadastrado')
      end
    end
  end
end
