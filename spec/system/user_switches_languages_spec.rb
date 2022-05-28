require 'rails_helper'

describe 'User lands on the app' do
  it 'and by default it is in Portuguese' do
    visit root_path

    expect(page).to have_css('header', text: 'Departamento de Envios')
    expect(page).not_to have_text('The requested language is not available. You were redirected to the English version of the website.')
  end

  it 'and switches language clicking on the button' do
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

  it 'requests an unsupported language, and are redirected to the English version' do
    visit '/users/sign_in/?locale=th'

    expect(page).to have_css('header', text: 'Shipping Department')
    expect(page).to have_text('The requested language is not available. You were redirected to the English version of the website.')
  end

  it 'change languages, and it is kept throughout navigation' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

    visit root_path
    fill_in 'Email', with: 'me@email.com'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'
    click_on 'en' # TODO this test breaks if user switch language before login
    click_on 'My Company'
    click_on 'My Service Orders'
    
    expect(page).to have_css('header', text: 'Shipping Department')
  end
end