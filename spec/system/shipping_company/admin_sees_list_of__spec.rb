require 'rails_helper'

describe 'Admin visits index for Shipping Companies and' do
  it 'sees a list of them' do
    ShippingCompany.create!(name: 'Transportes Marília',
                            status: 2,
                            legal_name: 'Transportes Marília Ltda',
                            email_domain: 'tma.com.br',
                            cnpj: 12345678904321,
                            billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
    ShippingCompany.create!(name: 'Cheirex',
                            status: 8,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      
    visit shipping_companies_path

    expect(page).not_to have_text('Nenhuma transportadora cadastrada')
    expect(page).to have_text('Cheirex')
    expect(page).to have_text('Transportes Marília')
    expect(page.text.index('Cheirex')).to be < page.text.index('Transportes Marília')
  end

  it 'but there are no companies to show' do
    visit shipping_companies_path

    expect(page).to have_text('Nenhuma transportadora cadastrada')
  end
end