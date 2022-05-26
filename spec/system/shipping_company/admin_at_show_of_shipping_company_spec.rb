require 'rails_helper'

describe 'Admin sees details of a Shipping Company' do
  it 'succesfully' do
    ShippingCompany.create!(name: 'Cheirex',
                            status: 2,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)  
    visit shipping_companies_path
    click_on 'Cheirex'
    
    expect(page).to have_text('Cheirex')
    expect(page).to have_text('Suspensa')
    expect(page).to have_text('Transportes Federais do Brasil S.A.')
    expect(page).to have_text('cheirex.com')
    expect(page).to have_text('12.345.678/9012-34')
    expect(page).to have_text('Av. das Nações Unidas, 1.532 - São Paulo, SP')
  end

  it 'and go back to Shipping Company index' do
    ShippingCompany.create!(name: 'Cheirex',
                            status: 2,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)  
    visit shipping_companies_path
    click_on 'Cheirex'
    click_on 'Voltar'

    expect(current_path).to eq(shipping_companies_path)
  end
end