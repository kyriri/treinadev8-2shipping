require 'rails_helper'

describe 'Admin sees details of a Shipping Company' do
  it 'succesfully' do
    ShippingCompany.create!(name: 'Cheirex',
                            status: 9,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      
    visit shipping_company_index_path
    click_on 'Cheirex'
    
    expect(page).to have_text('Cheirex')
    expect(page).to have_text('Status')
    expect(page).to have_text('Transportes Federais do Brasil S.A.')
    expect(page).to have_text('cheirex.com')
    expect(page).to have_text('12345678901234')
    expect(page).to have_text('Av. das Nações Unidas, 1.532 - São Paulo, SP')
  end

  it 'and go back to Shipping Company index' do
    ShippingCompany.create!(name: 'Cheirex',
                            status: 9,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      
    visit shipping_company_index_path
    click_on 'Cheirex'
    click_on 'Voltar'

    expect(current_path).to eq(shipping_company_index_path)
  end
end