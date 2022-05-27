require 'rails_helper'

describe 'User updates delivery history' do
  it 'clicking on buttons' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    serv_order = ServiceOrder.create!(shipping_company: sc1, status: 'accepted', package: Package.new)
    Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc1, service_order: serv_order, is_valid: true)
    outpost = Outpost.create!(shipping_company: sc1, name: 'Aeroporto', city_state: 'Confins, MG', category: 'centro de envios aéreos')
              Outpost.create!(shipping_company: sc1, name: 'Savassi', city_state: 'Belo Horizonte, MG', category: 'posto de entrega')
    delivery = Delivery.create!(service_order: serv_order, tracking_code: 'HU876592369BR')
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc1)
    stage = Stage.create!(delivery: delivery, outpost: outpost)

    login_as(user)
    visit root_path
    click_on 'Minhas Ordens de Serviço'
    click_on 'detalhes'
    click_on 'Aeroporto'

    expect(delivery.stages).to be
    expect(current_path).to eq service_order_path(serv_order)
    expect(page).to have_text('Passo de entrega cadastrado com sucesso.')
    expect(page).to have_text('Detalhes da entrega')
    expect(page).to have_text('posto de entrega')
    expect(page).to have_text('Savassi - Belo Horizonte, MG')
    # expect(page).to have_text('27/05/2022 13:57')
  end

  xit 'but buttons appear only for accepted service orders' do
  end

  xit 'and if marked as delivered, it also changes the service order status' do
    #also on file user_causes_status_to_update_spec.rb
  end
end