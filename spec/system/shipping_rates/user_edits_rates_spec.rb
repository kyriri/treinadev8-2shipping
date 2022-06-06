require 'rails_helper'

feature 'Shipping rates are editable' do
  context 'by a user' do
    it 'who can access the editing page and update prices (but not weights)' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', cubic_weight_const: 35, min_fee: 8, legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      ShippingRate.create!(max_weight_in_kg: 0.5, cost_per_km_in_cents: 20, shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 33, shipping_company: sc1)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
      
      login_as(user)
      visit root_path
      click_on 'Meus Preços & Prazos'
      within '#shipping_rates' do
        click_on 'editar'
      end

      expect(page).to have_text(sc1.name)
      expect(page).to have_text('Editar tabela de tarifas')
      expect(page).to have_field('até 0,5 kg', with: 20)
      expect(page).to have_field('até 1 kg', with: 33)
      expect(page).not_to have_css('input#shipping_company_shipping_rates_attributes_0_max_weight_in_kg')
    end

    it 'who receives a flash message on success' do
      sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', cubic_weight_const: 35, min_fee: 8, legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 20, shipping_company: sc1)
      ShippingRate.create!(max_weight_in_kg: 2.5, cost_per_km_in_cents: 21, shipping_company: sc1)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
      
      login_as(user)
      visit root_path
      click_on 'Meus Preços & Prazos'
      within '#shipping_rates' do
        click_on 'editar'
      end
      fill_in 'até 1 kg', with: '33'
      fill_in 'até 2,5 kg', with: '50'
      click_on 'Salvar'

      expect(current_path).to eq shipping_company_shipping_rates_path(sc1)
      expect(page).to have_text('Taxas atualizadas com sucesso')
      expect(page).to have_css('table', text: 'até 1 kg R$ 0,33 / km')
      expect(page).to have_css('table', text: 'até 2,5 kg R$ 0,50')
    end

    it 'who receives a flash message on failure' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', cubic_weight_const: 35, min_fee: 8, legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      rate = ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 20, shipping_company: sc)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)
      
      login_as(user)
      visit edit_shipping_company_shipping_rate_path(shipping_company_id: sc.id, id: rate.id)
      fill_in 'até 1 kg', with: ''
      click_on 'Salvar'

      expect(page).to have_text('Editar tabela de tarifas')
      expect(page).to have_text('Houve um erro. As taxas não foram atualizadas')
      expect(page).to have_text('Custo por km não pode ficar em branco')
      expect(page).to have_field('até 1 kg', with: 20)
    end
  end
end