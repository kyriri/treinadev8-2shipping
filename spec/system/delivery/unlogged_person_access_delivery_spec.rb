require 'rails_helper'

describe 'Unlogged user has a link' do
  it 'and access details of a delivery' do
    sc1 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
    serv_order = ServiceOrder.create!(shipping_company: sc1, status: 'accepted', package: Package.new)
    delivery = Delivery.create!(service_order: serv_order, tracking_code: 'HU876592369BR')
    outpost0 = Outpost.create!(shipping_company: sc1, name: 'Agência', city_state: 'São Paulo, SP', category: 'coletado')
    outpost1 = Outpost.create!(shipping_company: sc1, name: 'Aeroporto', city_state: 'Confins, MG', category: 'centro de envios aéreos')
    outpost2 = Outpost.create!(shipping_company: sc1, name: 'Savassi', city_state: 'Belo Horizonte, MG', category: 'posto de entrega')
    outpost3 = Outpost.create!(shipping_company: sc1, name: 'Domicílio indicado', city_state: 'Belo Horizonte, MG', category: 'entregue')
    stage3 = Stage.create!(delivery: delivery, outpost: outpost3, when: 1.day.ago)
    stage1 = Stage.create!(delivery: delivery, outpost: outpost1, when: 5.days.ago)
    stage0 = Stage.create!(delivery: delivery, outpost: outpost0, when: 6.day.ago)
    stage2 = Stage.create!(delivery: delivery, outpost: outpost2, when: 2.day.ago)

    visit delivery_path(delivery.tracking_code)

    expect(page).to have_css('table', text: 'Detalhes da entrega')
    expect(page).to have_text('HU876592369BR')
    expect(page).to have_text('posto de entrega')
    expect(page).to have_text('Savassi - Belo Horizonte, MG')
    expect(page.text.index('coletado')).to be < page.text.index('entregue')
    # TODO expect(page).to have_text('27/05/2022')
  end

  it 'but the code is wrong' do
    visit delivery_path('HJ0123XX')

    expect(page).to have_text('Código de rastreio HJ0123XX não encontrado')
  end
end