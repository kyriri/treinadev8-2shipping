require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  describe '#valid is false when' do
    it 'mandatory fields are blank' do
      cia = ShippingCompany.new(name: '',
                                legal_name: '',
                                cnpj: '',
                                status: '',
                                email_domain: '',
                                billing_address: '')
      
      cia.valid?

      expect(cia.errors.full_messages).to include('nome fantasia não pode ficar em branco')
      expect(cia.errors.full_messages).to include('razão social não pode ficar em branco')
      expect(cia.errors.full_messages).to include('CNPJ não pode ficar em branco')
      expect(cia.errors.full_messages).to include('status não pode ficar em branco')
      expect(cia.errors.full_messages).to include('domínio de email não pode ficar em branco')
      expect(cia.errors.full_messages).to include('endereço de faturamento não pode ficar em branco')
    end

    it 'mandatory fields are nil' do
      cia = ShippingCompany.new(name: nil,
                                legal_name: nil,
                                cnpj: nil,
                                status: nil,
                                email_domain: nil,
                                billing_address: nil)
      
      cia.valid?

      expect(cia.errors.full_messages).to include('CNPJ não pode ficar em branco')
    end

    it 'unique fields are repeated' do
      ShippingCompany.create!(name: 'Transportes Marília',
                              status: 'active',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tma.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
      cia = ShippingCompany.new(name: 'Transportes Marília',
                                cnpj: 12345678904321)

      cia.valid?

      expect(cia.errors.full_messages).to include('nome fantasia já está em uso')
      expect(cia.errors.full_messages).to include('CNPJ já está em uso')
    end

    it 'numerical fields receive other characers' do
      cia = ShippingCompany.new(cnpj: '123456-8904321',
                                cubic_weight_const: 'air cargo',
                                min_fee: 'twelve',
                               )
      cia.valid?

      expect(cia.errors.full_messages).to include('CNPJ deve conter apenas números')
      expect(cia.errors.full_messages).to include('fator para cálculo de peso cubado deve conter apenas números')
      expect(cia.errors.full_messages).to include('tarifa mínima deve conter apenas números')
    end

    it 'fields with specific length are not respected' do
      cia = ShippingCompany.new(cnpj: 1)

      cia.valid?

      expect(cia.errors.full_messages).to include('CNPJ deve ter 14 números')
    end
  end

  describe '#valid is true when' do
    it 'name is repeated from a deleted company' do
      ShippingCompany.create!(name: 'Transportes Marília',
                              status: 'deleted',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tam.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
    
      cia = ShippingCompany.new(name: 'Transportes Marília',
                                    status: 'in_registration',
                                    legal_name: 'Transportes Marília Ltda',
                                    email_domain: 'tam2022.com.br',
                                    cnpj: 12345678900001,
                                    billing_address: 'Av. do Aeroporto, 10 - Rio de Janeiro, RJ')
      expect(cia.valid?).to be true
    end

    it 'cnpj is repeated from a deleted company' do
      ShippingCompany.create!(name: 'Transportes Marília',
                              status: 'deleted',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tam.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
    
      cia = ShippingCompany.new(name: 'Transportes Cardoso',
                                    status: 'in_registration',
                                    legal_name: 'Transportes Cardoso Ltda',
                                    email_domain: 'cardoso.com.br',
                                    cnpj: 12345678904321,
                                    billing_address: 'Av. do Aeroporto, 10 - Rio de Janeiro, RJ')
      expect(cia.valid?).to be true
    end
  end

  describe '#find_delivery_time' do
    it 'selects the right delivery time' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 350,
                                    min_fee: 8)
      pack1 = Package.create!(distance_in_km: 45)
      DeliveryTime.create!(max_distance_in_km: 50,  delivery_time_in_buss_days: 2, shipping_company: sc1)
      DeliveryTime.create!(max_distance_in_km: 20,  delivery_time_in_buss_days: 1, shipping_company: sc1)

      response = sc1.find_delivery_time(pack1)

      expect(response.class).to be Integer
      expect(response).to eq 2
    end

    it 'return error message when distance is outside delivery range' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 350,
                                    min_fee: 8)
      pack1 = Package.create!(distance_in_km: 100)
      DeliveryTime.create!(max_distance_in_km: 50,  delivery_time_in_buss_days: 2, shipping_company: sc1)
      DeliveryTime.create!(max_distance_in_km: 20,  delivery_time_in_buss_days: 1, shipping_company: sc1)

      response = sc1.find_delivery_time(pack1)

      expect(response.class).to be String
      expect(response).to eq 'Distance outside service range'
    end
  end

  describe '#calculate_weight' do
    it 'returns the biggest of the weights (dead or cubic)' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 300,
                                    min_fee: 8)
      pack1 = Package.create!(volume_in_m3: 0.005, weight_in_g: 250)
      pack2 = Package.create!(volume_in_m3: 0.005, weight_in_g: 1700)

      response1 = sc1.calculate_weight(pack1)
      response2 = sc1.calculate_weight(pack2)

      expect(response1).to eq 1.5
      expect(response2).to eq 1.7
    end
  end
end
