require 'rails_helper'

describe 'Logged person visits details of a service order' do
  it 'succesfully' do
    package1 = Package.create!( width_in_cm: 14,
                                height_in_cm: 6,
                                length_in_cm: 21,
                                volume_in_m3: Float(14 * 6 * 21)/1_000_000,
                                weight_in_g: 250,
                                distance_in_km: 800,
                                pickup_address: 'Rodovia Dutra km 3, Guarulhos - SP',
                                delivery_address: 'Av. do Contorno 354 - Belo Horizonte, MG',
                                delivery_recipient_name: 'José Magela Amorim',
                                delivery_recipient_phone: '(31) 9 9453-8890',
                              )
    s_o = ServiceOrder.create!(status: 'unassigned', package: package1)

    visit service_orders_path
    click_on 'detalhes'

    expect(page).to have_text('Ordem de serviço nº 1')
    expect(current_path).to eq service_order_path(s_o)
    within '.package_details' do
      expect(page).to have_text('Dimensões')
      expect(page).to have_text('21 x 14 x 6 cm')
      expect(page).to have_text('Volume cúbico')
      expect(page).to have_text('0.001764 m³') # TODO apply i18n
      expect(page).to have_text('Peso')
      expect(page).to have_text('250 g')
      expect(page).to have_text('Endereço de retirada')
      expect(page).to have_text('Rodovia Dutra km 3, Guarulhos - SP')
      expect(page).to have_text('Dados para entrega')
      expect(page).to have_text('José Magela Amorim')
      expect(page).to have_text('(31) 9 9453-8890')
      expect(page).to have_text('Av. do Contorno 354 - Belo Horizonte, MG')
    end
  end
end