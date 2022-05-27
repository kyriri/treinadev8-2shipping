require 'rails_helper'

describe 'Admin tries to edit Shipping Company' do
  it 'and the correct radio button comes pre-selected' do
    ShippingCompany.create!(name: 'Cheirex',
                            status: 8,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit shipping_company_path(ShippingCompany.last.id)
    click_on 'Editar'

    expect(page).to have_checked_field('shipping_company_status_active')
    expect(page).not_to have_field('shipping_company_status_deleted')
  end

  it 'and it works' do
    ShippingCompany.create!(name: 'Cheirex',
                            status: 8,
                            legal_name: 'Transportes Federais do Brasil S.A.',
                            email_domain: 'cheirex.com',
                            cnpj: 12345678901234,
                            billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP',
                            cubic_weight_const: 600,
                            min_fee: 45)
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit shipping_company_path(ShippingCompany.last.id)
    click_on 'Editar'
    fill_in 'Nome fantasia', with: 'Cardboard master'
    fill_in 'Tarifa mínima', with: '12'
    choose 'suspensa', allow_label_click: true
    click_on 'Salvar'

    expect(page).to have_text('Dados atualizados com sucesso')
    expect(page).not_to have_text('Houve um erro. A atualização não foi feita')
    expect(page).to have_text('Cardboard master')
    expect(page).to have_text('Suspensa')
    expect(current_path).to eq(shipping_company_path(ShippingCompany.last.id))
  end

  it 'but receives an error message because input is unacceptable' do
    ShippingCompany.create!(name: 'Transportes Marília',
                            status: 2,
                            legal_name: 'Transportes Marília Ltda',
                            email_domain: 'tma.com.br',
                            cnpj: 12345678904321,
                            billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
    cia = ShippingCompany.create!(name: 'Cheirex',
                                  status: 8,
                                  legal_name: 'Transportes Federais do Brasil S.A.',
                                  email_domain: 'cheirex.com',
                                  cnpj: 12345678901234,
                                  billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit edit_shipping_company_path(cia.id)
    fill_in 'Nome fantasia', with: 'Transportes Marília'
    click_on 'Salvar'

    expect(page).not_to have_text('Dados atualizados com sucesso')
    expect(page).to have_text('Houve um erro. A atualização não foi feita')
    expect(page).to have_text('já está em uso')
    expect(page).to have_css('form')
    expect(page).to have_field('Domínio de email', with: 'cheirex.com')
    expect(page).not_to have_field('shipping_company_status_deleted')
  end

  it 'but gives up' do
    cia = ShippingCompany.create!(name: 'Cheirex',
                                  status: 8,
                                  legal_name: 'Transportes Federais do Brasil S.A.',
                                  email_domain: 'cheirex.com',
                                  cnpj: 12345678901234,
                                  billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
    admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

    login_as(admin)
    visit edit_shipping_company_path(cia.id)
    fill_in 'Nome fantasia', with: 'Transportes Marília'
    click_on 'Voltar'

    expect(current_path).to eq(shipping_company_path(cia.id))
    expect(page).to have_text('Cheirex')
  end
end