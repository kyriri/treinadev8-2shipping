require 'rails_helper'

describe 'User tries to create new outpost' do
  it 'and it works' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

    login_as(user)
    visit root_path
    click_on 'Meus Entrepostos'
    click_on 'Cadastrar novo entreposto'
    fill_in 'Nome', with: 'Loja III'
    fill_in 'Localidade', with: 'Porto Alegre, RS'
    fill_in 'Categoria', with: 'posto de coleta'
    click_on 'Cadastrar entreposto'

    expect(current_path).to eq shipping_company_outposts_path(user.shipping_company)
    expect(page).to have_text('O entreposto Loja III foi salvo com sucesso.')
    within '#outposts_container' do
      expect(page).to have_text('Loja III')
      expect(page).to have_text('Porto Alegre, RS')
      expect(page).to have_text('posto de coleta')
    end
  end

  it "but receives error message because input is unacceptable" do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    Outpost.create!(shipping_company: sc1, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de distribuição')
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

    login_as(user)
    visit new_shipping_company_outpost_path(user.shipping_company)
    click_on 'Cadastrar entreposto'

    expect(page).to have_text('Houve um erro. O entreposto não foi salvo.')
    expect(page).to have_text('Nome não pode ficar em branco')
  end

  it 'from the order page' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    serv_order = ServiceOrder.create!(shipping_company: sc1, status: 'accepted', package: Package.new)
    Delivery.create!(service_order: serv_order, tracking_code: 'PF876592369BR')
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

    login_as(user)
      visit service_order_path(serv_order)
      click_on 'Cadastrar novo entreposto'
      fill_in 'Nome', with: 'Loja III'
      fill_in 'Localidade', with: 'Porto Alegre, RS'
      fill_in 'Categoria', with: 'posto de coleta'
      click_on 'Cadastrar entreposto'
  
      expect(current_path).to eq service_order_path(serv_order)
  end
end