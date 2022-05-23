require 'rails_helper'

describe 'Logged person sees table of fees for a company' do
  it 'succesfully' do
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
    
    ShippingFee.create!(max_weight_in_kg: 1  , cost_per_km_in_cents: 60, shipping_company: sc1)
    ShippingFee.create!(max_weight_in_kg: 0.5, cost_per_km_in_cents: 55, shipping_company: sc1)
    ShippingFee.create!(max_weight_in_kg: 0.3, cost_per_km_in_cents: 50, shipping_company: sc1)
    ShippingFee.create!(max_weight_in_kg: 6  , cost_per_km_in_cents: 65, shipping_company: sc1)
    ShippingFee.create!(max_weight_in_kg: 2  , cost_per_km_in_cents: 51, shipping_company: sc2) # another company
      
    visit shipping_company_shipping_fees_path(sc1)

    expect(page).to have_text('Tabela de preços')
    expect(page).to have_text('Ibérica')
    expect(page).to have_text('até 0,3 kg')
    expect(page).to have_text('até 1 kg')
    expect(page).to have_text('R$ 0,60')
    expect(page).not_to have_text('até 2 kg')
    expect(page.text.index('até 0,5 kg')).to be < page.text.index('até 1 kg')
  end
end