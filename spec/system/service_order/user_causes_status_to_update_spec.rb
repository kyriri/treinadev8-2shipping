require 'rails_helper'

describe 'User sees' do
  it 'buttons to accept/reject order' do
    sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
    serv_order = ServiceOrder.create!(status: 'pending', shipping_company: sc1, package: Package.new(distance_in_km: 34))
    Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
    
    login_as(user)
    visit root_path
    click_on 'Minhas Ordens de Serviço'
    click_on 'detalhes'

    expect(page).to have_button('aceitar')
    expect(page).to have_button('rejeitar')
  end
end

describe 'The order status is updated correctly' do
  context 'when user' do
    it 'accepts an order (and it also creates a new Delivery)' do
      sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
      serv_order = ServiceOrder.create!(status: 'pending', shipping_company: sc1, package: Package.new(distance_in_km: 34))
      Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
      
      login_as(user)
      visit service_order_path(serv_order)
      click_on 'aceitar'

      expect(current_path).to eq service_orders_path
      expect(page).to have_text('A ordem foi aceita com sucesso.')
      expect(ServiceOrder.last.status).to eq 'accepted'
      expect(serv_order.delivery).to be
      expect(serv_order.delivery.tracking_code).to be
    end

    it 'rejects an order' do
      sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 10, min_fee: 5, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
      serv_order = ServiceOrder.create!(status: 'pending', shipping_company: sc1, package: Package.new(distance_in_km: 34))
      Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
      
      login_as(user)
      visit service_order_path(serv_order)
      click_on 'rejeitar'

      expect(current_path).to eq service_orders_path
      expect(page).to have_text('A ordem foi devolvida com sucesso.')
      expect(ServiceOrder.last.status).to eq 'rejected'
      expect(serv_order.delivery).not_to be
    end

    xit 'marks a Delivery as completed' do
    end
  end
end
