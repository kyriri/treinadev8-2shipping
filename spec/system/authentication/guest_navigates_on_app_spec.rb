require 'rails_helper'

describe 'Unlogged user visits the application and' do
  it 'sees application name' do
    visit '/'

    expect(page).to have_css('header', text: 'East Wing - Departamento de Envios')
  end

  it 'is redirected to login page' do
    visit '/shipping_companies/2'

    expect(current_path).to eq new_user_session_path
  end

  it 'is redirected to the desired page after login' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

    visit service_orders_path
    fill_in 'Email', with: 'me@email.com'
    fill_in 'Senha', with: '12345678'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq service_orders_path
  end
end