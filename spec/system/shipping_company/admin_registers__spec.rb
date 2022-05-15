require 'rails_helper'

describe 'Admin tries to register a Shipping Company' do
  it 'and it works' do
    visit shipping_companies_path
    click_on 'Cadastrar nova transportadora'
    fill_in 'Nome fantasia', with: 'Ibérica'
    fill_in 'Razão social', with: 'Transportadora Portuguesa Ltda'
    fill_in 'CNPJ', with: '12345678901111'
    fill_in 'Domínio de email', with: 'oniberica.com.br'
    fill_in 'Endereço de faturamento', with: 'Rua da Paz 45, Belém - PA'
    click_on 'Cadastrar transportadora'

    expect(page).to have_text('Registro feito com sucesso')
    expect(page).to have_text('Para ativar a transportadora, ela precisa primeiro enviar suas tabelas de preço e de prazos')
    expect(page).not_to have_text('Houve um erro. A transportadora não foi salva.')
    expect(page).to have_text('Ibérica')
    expect(page).to have_text('Transportadora Portuguesa Ltda')
    expect(page).to have_text('oniberica.com.br')
    expect(page).to have_text('Rua da Paz 45, Belém - PA')
    expect(current_path).to eq(shipping_company_path(ShippingCompany.last))
  end

  it 'but receives error msgs because input is unacceptable' do
    visit new_shipping_company_path
    fill_in 'CNPJ', with: '1234567890111'
    click_on 'Cadastrar transportadora'

    expect(page).to have_text('Houve um erro. A transportadora não foi salva.')
    expect(page).to have_text('não pode ficar em branco')
    expect(page).to have_css('form')
    expect(page).to have_field('CNPJ', with:'1234567890111')
  end
end