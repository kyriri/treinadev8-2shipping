require 'rails_helper'

describe 'Logged user' do
  context 'accesses details' do
    it 'of their own company and it works' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit root_path
      click_on 'Minha Empresa'

      expect(current_path).to eq shipping_company_path(sc1)
    end

    it 'of another company and they are redirected to homepage' do
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
      user_sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: user_sc)

      login_as(user)
      visit shipping_company_path(another_sc)

      expect(current_path).to eq root_path
    end

    it 'and then goes back to homepage' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit root_path
      click_on 'Minha Empresa'
      click_on 'Voltar'

      expect(current_path).to eq root_path
      expect(page).not_to have_text('Houve um erro. Sua requisição não pode ser completada.')
    end
  end

  context 'edits details' do
    it 'but cannot edit status' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit root_path
      click_on 'Minha Empresa'
      click_on 'Editar'

      expect(page).not_to have_text('ativa')
    end

    it 'of their own company and it works' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit edit_shipping_company_path(sc1)
      fill_in 'Nome', with: 'Merdex'
      click_on 'Salvar'

      expect(page).to have_text('Merdex')
    end

    it 'of another company, but are redirected to homepage' do
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit edit_shipping_company_path(another_sc)

      expect(page).to have_text('Houve um erro. Sua requisição não pode ser completada')
    end
  end
end

describe 'Logged user is blocked from' do
  it 'action index of shipping companies' do
    user = User.create!(email: 'me@email.com', password: '12345678')

    login_as(user)
    visit shipping_companies_path

    expect(current_path).to eq root_path
  end

  it 'action new of shipping companies' do
    user = User.create!(email: 'me@email.com', password: '12345678')

    login_as(user)
    visit new_shipping_company_path

    expect(current_path).to eq root_path
  end

  # xit 'action create of shipping companies' do
  #   user = User.create!(email: 'me@email.com', password: '12345678')

  #   login_as(user)
  #   post shipping_companies_path, params: {"shipping_company"=>{"name"=>"Cheirex"}}

  #   expect(response).to have_http_status :unauthorized # TODO test block of action create for user
  # end

  it 'seeing a button to delete its own shipping company' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit shipping_company_path(sc1)

      expect(page).not_to have_button('Apagar')
  end
end