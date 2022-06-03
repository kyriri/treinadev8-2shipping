require 'rails_helper'

describe 'User lands on the app' do
  it 'and by default it is in Portuguese' do
    visit root_path

    expect(page).to have_css('header', text: 'Departamento de Envios')
    expect(page).not_to have_text('The requested language is not available. You were redirected to the English version of the website.')
  end

  it 'and switches language clicking in a button' do
    visit root_path
    click_on 'en'

    expect(page).to have_text('Shipping Department')
    expect(page).to have_css('a[title="trocar para português"]')
  end

  it 'and requests Portuguese language succesfully' do
    visit '/?locale=pt-BR'

    expect(page).to have_css('header', text: 'Departamento de Envios')
  end

  it 'and requests English language succesfully' do
    visit '/users/sign_in/?locale=en'

    expect(page).to have_css('header', text: 'Shipping Department')
  end

  it 'and trailing spaces for language do not affect behavior' do
    visit '/users/sign_in/?locale=en '

    expect(page).to have_css('header', text: 'Shipping Department')
  end

  it 'requests an unsupported language, and is redirected to the English version' do
    visit '/users/sign_in/?locale=th'

    expect(page).to have_css('header', text: 'Shipping Department')
    expect(page).to have_text('The requested language is not available. You were redirected to the English version of the website.')
  end

  it 'change languages, and the choice is kept throughout navigation' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

      visit root_path
      click_on 'en'
      fill_in 'Email', with: 'me@email.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'
      click_on 'en' # TODO devise unfortunately "forgets" user locale
      click_on 'My Service Orders'
      click_on 'pt-BR'
      click_on 'detalhes'
      click_on 'en'
    
    expect(page).to have_css('header', text: 'Shipping Department')
    expect(page).to have_text('Service Order # 1')
  end

  it 'it sees values in local currency, but with English format' do
    sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    serv_order = ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
    Quote.create!(chosen: true, fee: 21.24, delivery_time: 2, quote_group: "WYV-UUG", shipping_company: sc, service_order: serv_order, is_valid: true)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

    login_as(user)
    visit root_path
    click_on 'en'
    click_on 'My Service Orders'
    click_on 'details'
  
    expect(page).to have_text('21.24 BRL')
  end
end