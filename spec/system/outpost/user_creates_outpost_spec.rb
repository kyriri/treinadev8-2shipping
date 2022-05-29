require 'rails_helper'
describe 'User tries to create new outpost' do
  it 'and it works' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

    login_as(user)
    visit root_path
    click_on 'Meus Entrepostos'
    click_on 'Cadastrar novo entreposto'
    # TODO it is failling at form creation, probably because it's a nested route
    fill_in 'Nome', with: 'Loja III'
    fill_in 'Localidade', with: 'Porto Alegre, RS'
    fill_in 'Categoria', with: 'posto de coleta'
    click_on 'Cadastrar entreposto'

    expect(current_path).to eq shipping_company_outposts_path(user.shipping_company)
    expect(page).to have_text('Loja III')
    expect(page).to have_text('Porto Alegre, RS')
    expect(page).to have_text('posto de coleta')
  end

  xit "and it doesn't work because there's already a similar active outpost" do
  end
end