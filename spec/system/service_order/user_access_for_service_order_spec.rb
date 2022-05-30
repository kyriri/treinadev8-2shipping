require 'rails_helper'

describe 'Normal user' do
  context 'can see' do
    it "a list of their company's orders" do
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      ServiceOrder.create!(shipping_company: sc1, status: 'pending', package: Package.new)
      ServiceOrder.create!(shipping_company: sc1, status: 'pending', package: Package.new)
      ServiceOrder.create!(shipping_company: sc1, status: 'accepted', package: Package.new)
      ServiceOrder.create!(shipping_company: sc1, status: 'delivered', package: Package.new)
      ServiceOrder.create!(shipping_company: another_sc, status: 'pending', package: Package.new)
      ServiceOrder.create!(shipping_company: another_sc, status: 'accepted', package: Package.new)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit root_path
      click_on 'Minhas Ordens de Serviço'

      within '.pending' do
        expect(page).to have_text('Novas')
        expect(page).to have_text('ID: 1')
        expect(page).to have_text('ID: 2')
        expect(page).not_to have_text('ID: 5') # another company's
      end
      within '.accepted' do
        expect(page).to have_text('Em processo de entrega')
        expect(page).to have_text('ID: 3')
        expect(page).not_to have_text('ID: 6') # another company's
      end
      within '.delivered' do
        expect(page).to have_text('Entregues')
        expect(page).to have_text('ID: 4')
      end
      # TODO show price on summary
    end

    it 'warnings that there are no orders to show' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit service_orders_path

      expect(page).to have_text('Nenhuma ordem de serviço', count: 3)
    end

    it "details of a order for their company" do
      package1 = Package.create!(width_in_cm: 14,
                                height_in_cm: 6,
                                length_in_cm: 21,
                                volume_in_m3: Float(14 * 6 * 21)/1_000_000,
                                weight_in_g: 250,
                                distance_in_km: 800,
                                pickup_address: 'Rodovia Dutra km 3, Guarulhos - SP',
                                delivery_address: 'Av. do Contorno 354 - Belo Horizonte, MG',
                                delivery_recipient_name: 'José Magela Amorim',
                                delivery_recipient_phone: '(31) 9 9453-8890',
                              )
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      serv_order = ServiceOrder.create!(status: 'pending', package: package1, shipping_company: sc1)
      Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit service_orders_path
      click_on 'detalhes'

      expect(page).to have_text('Ordem de Serviço nº 1')
      expect(current_path).to eq service_order_path(serv_order)
      within '.package_details' do
        expect(page).to have_text('Dimensões')
        expect(page).to have_text('21 x 14 x 6 cm')
        expect(page).to have_text('Volume cúbico')
        expect(page).to have_text('0.001764 m³') # TODO apply i18n
        expect(page).to have_text('Peso')
        expect(page).to have_text('250 g')
        expect(page).to have_text('Endereço de retirada')
        expect(page).to have_text('Rodovia Dutra km 3, Guarulhos - SP')
        expect(page).to have_text('Dados para entrega')
        expect(page).to have_text('José Magela Amorim')
        expect(page).to have_text('(31) 9 9453-8890')
        expect(page).to have_text('Av. do Contorno 354 - Belo Horizonte, MG')
      end
    end
  end

  context 'cannot see' do
    it "details of another company's order" do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
      s_o = ServiceOrder.create!(shipping_company: another_sc, status: 'pending', package: Package.create!())
      user = User.create!(shipping_company: sc1, email: 'me@email.com', password: '12345678')

      login_as(user)
      visit service_order_path(s_o)

      expect(current_path).to eq root_path
    end
  end
end