require 'rails_helper'

describe 'Admin pushes delete button at a Shipping Company' do
  it 'and its status changes to deleted' do
    cia = ShippingCompany.create!(name: 'Transportes Marília',
                                  status: 2,
                                  legal_name: 'Transportes Marília Ltda',
                                  email_domain: 'tma.com.br',
                                  cnpj: 12345678904321,
                                  billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
  
  visit shipping_company_path(cia.id)
  click_on 'Apagar'

  expect(page).to have_text('Transportadora Transportes Marília apagada com sucesso')
  expect(page).not_to have_css('ul', text: 'Transportes Marília')
  expect(current_path).to eq(shipping_companies_path)
  expect(ShippingCompany.find(cia.id).status).to eq('deleted')
  end
end