require 'rails_helper'

describe 'Normal user can see rates & times' do
  it 'of its own company' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', cubic_weight_const: 35, min_fee: 8, legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 60, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 20, delivery_time_in_buss_days: 1, shipping_company: sc1)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
    
    login_as(user)
    visit root_path
    click_on 'Meus Preços & Prazos'

    expect(current_path).to eq shipping_company_shipping_rates_path(sc1)
    expect(page).to have_text('Cheirex')
    expect(page).to have_text('Informações para cálculo de tarifas')
    expect(page).to have_text('até 1 kg')
    expect(page).to have_text('R$ 0,60')
  end

  it 'but not of other companies' do
    another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
    user_sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: user_sc)

    login_as(user)
    visit shipping_company_shipping_rates_path(another_sc)

    expect(current_path).to eq root_path
  end

  it 'and then go back to the previous page' do
    user_sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: user_sc)

    login_as(user)
    visit root_path
    click_on 'Meus Preços & Prazos'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end

describe 'Admin access rates & times' do
  it "and sees the company's variables" do
    sc1 = ShippingCompany.create!(name: 'Ibérica',
                                  status: 'in_registration',
                                  legal_name: 'Ibérica dos Transportes Ltda',
                                  email_domain: 'iberica.com.br',
                                  cnpj: 98765432101234,
                                  billing_address: 'Rua da Paz, 34 - Rio Branco, AC',
                                  cubic_weight_const: 300,
                                  min_fee: 10)
    sc2 = ShippingCompany.create!(name: 'Cheirex',
                                  status: 'deleted',
                                  legal_name: 'Transportes Federais do Brasil S.A.',
                                  email_domain: 'cheirex.com',
                                  cnpj: 12345678901234,
                                  billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', 
                                  cubic_weight_const: 350,
                                  min_fee: 8)           
    admin = User.create!(admin:true, email: 'me@email.com', password: '12345678')

    login_as(admin)
    visit shipping_companies_path
    click_on 'taxas'

    expect(page).to have_text('Ibérica')
    expect(page).to have_text('Valor mínimo')
    expect(page).to have_text('R$ 10,00')
    expect(page).to have_text('Fator para cálculo de peso cubado')
    expect(page).to have_text('300 kg/m³')
    expect(page).not_to have_text('Cheirex')
    expect(page).not_to have_text('350 kg/m³')
  end

  it "sees the company's table of rates" do
    sc1 = ShippingCompany.create!(name: 'Ibérica',
                                  status: 'in_registration',
                                  legal_name: 'Ibérica dos Transportes Ltda',
                                  email_domain: 'iberica.com.br',
                                  cnpj: 98765432101234,
                                  billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
    sc2 = ShippingCompany.create!(name: 'Cheirex',
                                  status: 'active',
                                  legal_name: 'Transportes Federais do Brasil S.A.',
                                  email_domain: 'cheirex.com',
                                  cnpj: 12345678901234,
                                  billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')                              
    
    ShippingRate.create!(max_weight_in_kg: 1  , cost_per_km_in_cents: 60, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 0.5, cost_per_km_in_cents: 55, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 0.3, cost_per_km_in_cents: 50, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 6  , cost_per_km_in_cents: 65, shipping_company: sc1)
    ShippingRate.create!(max_weight_in_kg: 2  , cost_per_km_in_cents: 51, shipping_company: sc2) # another company
    admin = User.create!(admin:true, email: 'me@email.com', password: '12345678')

    login_as(admin)  
    visit shipping_company_shipping_rates_path(sc1)

    expect(page).to have_text('Tabela de tarifas')
    expect(page).to have_text('até 0,3 kg')
    expect(page).to have_text('R$ 0,50')
    expect(page).to have_text('até 1 kg')
    expect(page).not_to have_text('até 2 kg')
    expect(page.text.index('até 0,5 kg')).to be < page.text.index('até 1 kg')
  end

  it "sees the company's table of delivery times" do
    sc1 = ShippingCompany.create!(name: 'Ibérica',
                                  status: 'in_registration',
                                  legal_name: 'Ibérica dos Transportes Ltda',
                                  email_domain: 'iberica.com.br',
                                  cnpj: 98765432101234,
                                  billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
    sc2 = ShippingCompany.create!(name: 'Cheirex',
                                  status: 'active',
                                  legal_name: 'Transportes Federais do Brasil S.A.',
                                  email_domain: 'cheirex.com',
                                  cnpj: 12345678901234,
                                  billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')                              
    admin = User.create!(admin:true, email: 'me@email.com', password: '12345678')

    login_as(admin)
    DeliveryTime.create!(max_distance_in_km: 800, delivery_time_in_buss_days: 3, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 50, delivery_time_in_buss_days: 2, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 20, delivery_time_in_buss_days: 1, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 150, delivery_time_in_buss_days: 3, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 400, delivery_time_in_buss_days: 4, shipping_company: sc1)
    DeliveryTime.create!(max_distance_in_km: 555, delivery_time_in_buss_days: 8, shipping_company: sc2) # another company
      
    visit shipping_company_shipping_rates_path(sc1)

    expect(page).to have_text('Tabela de prazos')
    expect(page).to have_text('até 20 km')
    expect(page).to have_text('1 dia útil')
    expect(page).to have_text('2 dias úteis')
    expect(page).not_to have_text('até 555 km')
    expect(page.text.index('até 20 km')).to be < page.text.index('até 800 km')
  end

  it 'and go back to the previous page' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', cubic_weight_const: 35, min_fee: 8, legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    admin = User.create!(admin:true, email: 'me@email.com', password: '12345678')

    login_as(admin)
    visit root_path
    click_on 'Transportadoras'
    click_on 'taxas'
    click_on 'Voltar'

    expect(current_path).to eq shipping_companies_path
  end 
end