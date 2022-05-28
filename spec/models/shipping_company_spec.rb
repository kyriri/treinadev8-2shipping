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

    it 'return falsey value when distance is too big' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 350,
                                    min_fee: 8)
      pack1 = Package.create!(distance_in_km: 100)
      DeliveryTime.create!(max_distance_in_km: 50,  delivery_time_in_buss_days: 2, shipping_company: sc1)
      DeliveryTime.create!(max_distance_in_km: 20,  delivery_time_in_buss_days: 1, shipping_company: sc1)

      response = sc1.find_delivery_time(pack1)

      expect(response).to be nil
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

      expect(response1).to eq 1.5 # cubic weight = 300 * 0.005
      expect(response2).to eq 1.7 # dead weight
    end
  end

  describe '#find_rate' do
    it 'selects the right rate' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 350,
                                    min_fee: 8)
      ShippingRate.create!(max_weight_in_kg: 0.3, cost_per_km_in_cents: 5,   shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 5  , cost_per_km_in_cents: 66,  shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 0.5, cost_per_km_in_cents: 9,   shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 1  , cost_per_km_in_cents: 33,  shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 10 , cost_per_km_in_cents: 100, shipping_company: sc1)
      weight1 = 0.25
      weight2 = 5
      weight3 = 5.01
      weight4 = 10

      response1 = sc1.find_rate(weight1)
      response2 = sc1.find_rate(weight2)
      response3 = sc1.find_rate(weight3)
      response4 = sc1.find_rate(weight4)

      expect(response1.class).to be Integer
      expect(response1).to eq 5
      expect(response2).to eq 66
      expect(response3).to eq 100
      expect(response4).to eq 100
    end
    
    it 'returns falsey value when weight is too heavy' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 350,
                                    min_fee: 8)
      ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 50, shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 5, cost_per_km_in_cents: 70, shipping_company: sc1)
      weight = 100

      response = sc1.find_rate(weight)

      expect(response).to be nil
    end
  end

  describe '#calculate_fee' do
    it 'returns the biggest of the rates (minimal or calculated)' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                    cubic_weight_const: 300,
                                    min_fee: 5)
      pack1 = Package.create!(distance_in_km: 2)
      pack2 = Package.create!(distance_in_km: 100)
      rate = 99

      response1 = sc1.calculate_fee(pack1, rate)
      response2 = sc1.calculate_fee(pack2, rate)

      expect(response1).to eq 5   # minimal fee
      expect(response2).to eq 9.9 # calculated fee
    end
  end

  describe '#quote_for' do
    it 'returns a valid quote' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                              cubic_weight_const: 300,
                              min_fee: 5)
      package = Package.create!(volume_in_m3: 0.01,
                                weight_in_g: 800,
                                distance_in_km: 100)
      serv_order = ServiceOrder.create!(status: 'pending', package: package, shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 10, shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 5, cost_per_km_in_cents: 99, shipping_company: sc1)
      DeliveryTime.create!(max_distance_in_km: 40, delivery_time_in_buss_days: 1, shipping_company: sc1)
      DeliveryTime.create!(max_distance_in_km: 150, delivery_time_in_buss_days: 2, shipping_company: sc1)

      response = sc1.quote_for(serv_order, 'AAV-546')

      expect(response.shipping_company).to eq sc1
      expect(response.service_order).to eq serv_order
      expect(response.fee).to eq 9.9 # dead weight: 0.8 | cubic weight: 300 * 0.01 = 3 -> 99 * 100 = 9900 cents
      expect(response.delivery_time).to eq 2
      expect(response.is_valid).to be true
    end

    context 'returns an invalid quote' do
      it 'because package is too heavy' do
        sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                cubic_weight_const: 300,
                                min_fee: 5)
        package = Package.create!(volume_in_m3: 1,
                                  weight_in_g: 2_000,
                                  distance_in_km: 100)
        serv_order = ServiceOrder.create!(status: 'pending', package: package, shipping_company: sc1)
        ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 10, shipping_company: sc1)
        DeliveryTime.create!(max_distance_in_km: 40, delivery_time_in_buss_days: 1, shipping_company: sc1)

        response = sc1.quote_for(serv_order, 'AAV-546')

        expect(response.shipping_company).to eq sc1
        expect(response.service_order).to eq serv_order
        expect(response.fee).to be nil
        expect(response.delivery_time).to be nil
        expect(response.is_valid).to be false
      end

      it 'because distance is too far' do
        sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234,
                                cubic_weight_const: 1,
                                min_fee: 5)
        package = Package.create!(volume_in_m3: 0.001,
                                  weight_in_g: 750,
                                  distance_in_km: 1_000)
        serv_order = ServiceOrder.create!(status: 'pending', package: package, shipping_company: sc1)
        ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 10, shipping_company: sc1)
        DeliveryTime.create!(max_distance_in_km: 40, delivery_time_in_buss_days: 1, shipping_company: sc1)

        response = sc1.quote_for(serv_order, 'TH-0875')

        expect(response.shipping_company).to eq sc1
        expect(response.service_order).to eq serv_order
        expect(response.fee).to be nil
        expect(response.delivery_time).to be nil
        expect(response.is_valid).to be false
      end
    end
  end

  describe '#create_default_outposts' do
    it 'works' do
      sc1 = ShippingCompany.new(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
      
      sc1.save

      expect(sc1.outposts.size).to be 2
      expect(sc1.outposts.first.category).to eq 'coletado'
      expect(sc1.outposts.last.category).to eq 'entregue'
    end
  end
end
