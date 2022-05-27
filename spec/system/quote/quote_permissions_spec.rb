require 'rails_helper'

describe  "User doesn't see" do
  it 'quotes' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 10, min_fee: 5)
    serv_order = ServiceOrder.create!(shipping_company: sc1, status: 'pending', package: Package.new)
    Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
    user = User.create!(shipping_company: sc1, email: 'me@email.com', password: '12345678')

    login_as(user)
    visit service_orders_path
    click_on 'detalhes'

    expect(page).not_to have_text('Orçamento')
  end
end

describe 'Admin sees' do
  it 'notice if no quotes were asked yet' do
    s_o = ServiceOrder.create!(status: 'unassigned', package: Package.new(weight_in_g: 100))
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 10, min_fee: 5)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit service_order_path(s_o)

    expect(page).to have_text('Nenhum orçamento feito até agora')
  end

  it 'all quotes at a service order page' do
    package1 = Package.create!(distance_in_km: 800, width_in_cm: 14, height_in_cm: 6, length_in_cm: 21, volume_in_m3: Float(14 * 6 * 21)/1_000_000, weight_in_g: 250, pickup_address: 'Rodovia Dutra km 3, Guarulhos - SP', delivery_address: 'Av. do Contorno 354 - Belo Horizonte, MG', delivery_recipient_name: 'José Magela Amorim', delivery_recipient_phone: '(31) 9 9453-8890')
    s_o = ServiceOrder.create!(status: 'unassigned', package: package1)
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 10, min_fee: 5)
    sc2 = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
    ShippingRate.create!(max_weight_in_kg: 0.3, cost_per_km_in_cents: 50, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 1  , cost_per_km_in_cents: 60, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 55, shipping_company: sc2)
    ShippingRate.create!(max_weight_in_kg: 7, cost_per_km_in_cents: 50, shipping_company: sc2)
    
    DeliveryTime.create!(max_distance_in_km: 55, delivery_time_in_buss_days: 2, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 888, delivery_time_in_buss_days: 4, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 20, delivery_time_in_buss_days: 1, shipping_company: sc2)
    DeliveryTime.create!(max_distance_in_km: 1_000, delivery_time_in_buss_days: 8, shipping_company: sc2)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit service_orders_path
    click_on 'detalhes'
    click_on 'Obter orçamentos'

    expect(current_path).to eq service_order_path(s_o)
    expect(page).to have_text('Orçamentos')
    within 'table' do
      expect(page).to have_text('Cheirex')
      expect(page).to have_text('R$ 40,00')
      expect(page).to have_text('4 dias úteis')
      expect(page).to have_text('Ibérica')
      expect(page).to have_text('R$ 44,00')
      expect(page).to have_text('8 dias úteis')
    end
  end

  it 'a notice if no company is active' do
    s_o = ServiceOrder.create!(status: 'unassigned', package: Package.new(weight_in_g: 100))
    sc1 = ShippingCompany.create!(status: 'suspended', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 10, min_fee: 5)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit service_order_path(s_o)
    click_on 'Obter orçamentos'

    expect(page).to have_text('Não existem transportadoras ativas')
  end

  it 'a notice if no quotes were valid' do
    s_o = ServiceOrder.create!(status: 'unassigned', package: Package.new(volume_in_m3: 0.1, weight_in_g: 100))
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 10, min_fee: 5)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit service_order_path(s_o)
    click_on 'Obter orçamentos'

    expect(page).to have_text('Nenhuma transportadora ativa oferece serviços compatíveis')
  end 

  it 'a button to get fresh quotes' do
    package1 = Package.create!(distance_in_km: 800, width_in_cm: 14, height_in_cm: 6, length_in_cm: 21, volume_in_m3: Float(14 * 6 * 21)/1_000_000, weight_in_g: 250, pickup_address: 'Rodovia Dutra km 3, Guarulhos - SP', delivery_address: 'Av. do Contorno 354 - Belo Horizonte, MG', delivery_recipient_name: 'José Magela Amorim', delivery_recipient_phone: '(31) 9 9453-8890')
    s_o = ServiceOrder.create!(status: 'unassigned', package: package1)
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234, cubic_weight_const: 10, min_fee: 5)
    ShippingRate.create!(max_weight_in_kg: 1  , cost_per_km_in_cents: 60, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 888, delivery_time_in_buss_days: 4, shipping_company: sc1)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit service_orders_path
    click_on 'detalhes'
    click_on 'Obter orçamentos'

    expect(page).to have_text('Cheirex')
    expect(page).to have_text('R$ 48,00')
    expect(page).to have_button('Obter novos orçamentos')
  end

  it 'sees the latest set of quotes if there are many' do
    serv_order = ServiceOrder.create!(status: 'unassigned', package: Package.new(distance_in_km: 34))
    sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
    sc2 = ShippingCompany.create!(status: 'active', cubic_weight_const: 30, min_fee: 10, name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
    sc3 = ShippingCompany.create!(status: 'active', cubic_weight_const: 600, min_fee: 45, name: 'Air Cargo', legal_name: 'Empresa Brasileira de Transporte de Cargas Ltda', email_domain: 'aircargo.com.br', cnpj: 54321678900011, billing_address: 'Av. Atlântica, Rio de Janeiro - RJ')
    ShippingRate.create!(max_weight_in_kg: 2, cost_per_km_in_cents: 60, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 3, cost_per_km_in_cents: 55, shipping_company: sc2)
    DeliveryTime.create!(max_distance_in_km: 550, delivery_time_in_buss_days: 2, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 1_000, delivery_time_in_buss_days: 8, shipping_company: sc2)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)
    Quote.create!(fee: 45, delivery_time: 1, quote_group: "AXG-NTQ", shipping_company: sc3, service_order: serv_order, is_valid: true)
    Quote.create!(fee: 10, delivery_time: 5, quote_group: "AXG-NTQ", shipping_company: sc2, service_order: serv_order, is_valid: true)
    Quote.create!(fee: 21.24, delivery_time: 2, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
    Quote.create!(fee: 19.47, delivery_time: 8, quote_group: "WYV-UUG", shipping_company: sc2, service_order: serv_order, is_valid: true)
    
    login_as(admin)
    visit service_order_path(serv_order)

    expect(page).not_to have_text('Air Cargo') # participated only on the older quote group
    expect(page).to have_text('Cheirex')
    expect(page).to have_text('R$ 21,24')
    expect(page).to have_text('2 dias úteis')
    expect(page).to have_text('Ibérica')
    expect(page).to have_text('R$ 19,47')
    expect(page).to have_text('8 dias úteis')
  end
end

