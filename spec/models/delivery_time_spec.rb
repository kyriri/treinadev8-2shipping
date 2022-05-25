require 'rails_helper'

RSpec.describe DeliveryTime, type: :model do
  describe '#valid' do
    context 'should be false if' do
      it 'a distance was already in database' do
        sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 300, min_fee: 5)
        DeliveryTime.create!(max_distance_in_km: 20, shipping_company: sc1, delivery_time_in_buss_days: 1)
        dt = DeliveryTime.new(max_distance_in_km: 20, shipping_company: sc1, delivery_time_in_buss_days: 8)

        dt.valid?

        expect(dt.errors.full_messages).to include('distância máxima já cadastrada')
      end

      it 'no shipping company is associated to delivery time' do
        dt = DeliveryTime.new(max_distance_in_km: 20, delivery_time_in_buss_days: 8)

        dt.valid?

        expect(dt.errors.full_messages).to include('transportadora precisa constar na informação da taxa')
      end
    end
    
    context 'should be true if' do
      it 'the distance was already on database, but for another company' do
        sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 300, min_fee: 5)
        sc2 = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', min_fee: 10)
        DeliveryTime.create!(max_distance_in_km: 20, shipping_company: sc1, delivery_time_in_buss_days: 1)
        dt = DeliveryTime.new(max_distance_in_km: 20, shipping_company: sc2, delivery_time_in_buss_days: 8)

        response = dt.valid?

        expect(response).to be true
        expect(dt.errors.full_messages).not_to include('distância máxima já cadastrada')
      end
    end
  end
end
