require 'rails_helper'

describe 'User visits page listing' do
  context 'their own outposts' do
    it 'succesfully' do 
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
      Outpost.create!(shipping_company: sc1, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de coleta')
      Outpost.create!(shipping_company: sc1, name: 'Aeroporto', city_state: 'Confins, MG', category: 'centro de envios aéreos')
      Outpost.create!(shipping_company: another_sc, name: 'Foro', city_state: 'Teresina, PI', category: 'regional II')
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit root_path
      click_on 'Meus Entrepostos'

      expect(current_path).to eq shipping_company_outposts_path(sc1)
      expect(page).to have_content('Zona Sul - São Paulo, SP')
      expect(page).to have_content('centro de coleta')
      expect(page).to have_content('Aeroporto - Confins, MG')
      expect(page).to have_content('centro de envios aéreos')
      expect(page).not_to have_content('Foro - Teresina, PI') # from another company
      expect(page).not_to have_content('regional II')
    end

    it 'but not the default outposts' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit shipping_company_outposts_path(sc1)

      expect(page).to have_content('Nenhum entreposto cadastrado')
      expect(page).not_to have_content('coletado')
      expect(page).not_to have_content('entregue')
    end
  end

  context "other company's outposts" do
    it 'and is redirected to homepage' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', cubic_weight_const: 30, min_fee: 10)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)

      login_as(user)
      visit shipping_company_outposts_path(another_sc)

      expect(current_path).to eq root_path
    end
  end
end