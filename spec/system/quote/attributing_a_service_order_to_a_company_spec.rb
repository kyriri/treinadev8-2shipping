require 'rails_helper'

describe 'Admin' do
  context 'has a button for each quote' do
    it 'that attributes a service order to a company' do
      serv_order = ServiceOrder.create!(status: 'unassigned', package: Package.new(distance_in_km: 34))
      sc2 = ShippingCompany.create!(status: 'active', cubic_weight_const: 30, min_fee: 10, name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
      sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
      admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)
      Quote.create!(fee: 21.24, delivery_time: 2, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
      Quote.create!(fee: 19.47, delivery_time: 8, quote_group: "WYV-UUG", shipping_company: sc2, service_order: serv_order, is_valid: true)
      
      login_as(admin)
      visit service_order_path(serv_order)
      within 'tr[data-carrier="2"]' do
        click_on 'escolher'
      end

      expect(ServiceOrder.last.status).to eq 'pending'
      expect(ServiceOrder.last.shipping_company).to eq sc1
      expect(Quote.first.chosen).to eq true
      expect(page).to have_text('Ordem de serviço enviada para Cheirex')
      expect(page).to have_text('Cheirex R$ 21,24 2 dias úteis')
      expect(page).to have_text('Ibérica R$ 19,47 8 dias úteis')
      expect(page).not_to have_button('escolher')
      within 'tr[data-carrier="2"]' do
        expect(page).to have_text('aguardando confirmação')
      end
    end
  end

  context "doesn't see" do
    it 'button for accept/reject service order' do
      sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
      serv_order = ServiceOrder.create!(status: 'pending', shipping_company: sc1, package: Package.new(distance_in_km: 34))
      admin = User.create!(admin: true, email: 'me@email.com', password: '12345678')
      
      login_as(admin)
      visit service_order_path(serv_order)

      expect(page).not_to have_button('aceitar')
      expect(page).not_to have_button('rejeitar')
    end
  end
end

describe 'User' do
  context 'sees' do
    it 'the quote value of the moment the admin chose it' do
      sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
      serv_order = ServiceOrder.create!(status: 'pending', shipping_company: sc1, package: Package.new(distance_in_km: 34))
      Quote.create!(fee: 27.00, delivery_time: 1, chosen: false,  quote_group: "90A-P4B", shipping_company: sc1, service_order: serv_order, is_valid: true)
      Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
      
      login_as(user)
      visit root_path
      click_on 'Minhas Ordens de Serviço'
      click_on 'detalhes'

      expect(page).to have_text('Valor do serviço')
      expect(page).to have_text('R$ 21,24')
      expect(page).to have_text('2 dias úteis')
      expect(page).not_to have_text('R$ 27,00')
      expect(page).not_to have_text('1 dia útil')
    end
  end
end