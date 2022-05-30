require 'rails_helper'

describe 'User soft deletes outpost' do
  it 'succesfully' do
    sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    o1 = Outpost.create!(shipping_company: sc, name: 'Aeroporto', city_state: 'Confins, MG', category: 'centro de envios aéreos')
    o2 = Outpost.create!(shipping_company: sc, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de coleta')
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)
    o1_id = o1.id
    o2_id = o2.id

    login_as(user)
    visit shipping_company_outposts_path(sc)
    first(".delete_button").click

    expect(Outpost.find(o1_id).deleted_at).to be
    expect(Outpost.find(o2_id).deleted_at).not_to be
    expect(current_path).to eq shipping_company_outposts_path(sc)
    expect(page).to have_text('Entreposto Aeroporto - Confins, MG apagado com sucesso')
    within '#outposts_container' do
      expect(page).not_to have_text('Aeroporto')
      expect(page).to have_text('Zona Sul')
    end
  end

  it "and it doesn't show on service orders page either" do
    sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    o1 = Outpost.create!(shipping_company: sc, name: 'Aeroporto', city_state: 'Confins, MG', category: 'centro de envios aéreos')
    o2 = Outpost.create!(shipping_company: sc, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de coleta')
    serv_order = ServiceOrder.create!(status: 'accepted', shipping_company: sc, package: Package.new(distance_in_km: 34))
    delivery = Delivery.create!(service_order: serv_order, tracking_code: 'HU876592369BR')
    user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

    login_as(user)
    visit shipping_company_outposts_path(sc)
    first(".delete_button").click
    click_on 'Minhas Ordens de Serviço'
    click_on 'detalhes'

    expect(page).not_to have_text('Aeroporto')
    expect(page).to have_text('Zona Sul')
  end
end