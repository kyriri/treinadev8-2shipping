require 'rails_helper'

describe 'Admin visits homepage and' do
  xit 'see a summary of packages awaiting shipping' do
    Package.create!(width_in_cm: 14,
                    height_in_cm: 6,
                    length_in_cm: 21,
                    volume_in_m3: Float(14 * 6 * 21)/1_000_000,
                    weight_in_g: 250,
                    distance_in_km: 800,
                    pickup_address: 'Rodovia Dutra km3, Guarulhos - SP',
                    delivery_address: 'Av. do Contorno 354 - Belo Horizonte, MG',
                    delivery_recipient_name: 'José Magela Amorim',
                    delivery_recipient_phone: '(31) 9 9453-8890',
                    service_order: ServiceOrder.new(status: 0),
                   )
    visit root_path
    expect(page).to have_text('Encomendas novas (sem ordem de serviço): 1')
  end
end