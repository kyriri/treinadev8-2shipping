require 'rails_helper'

describe 'Admin visits index of service orders and' do
  it 'see new service orders' do
    ServiceOrder.create!(status: 'canceled', package: Package.new)
    ServiceOrder.create!(status: 'unassigned', package: Package.new)
    ServiceOrder.create!(status: 'unassigned', package: Package.new)
    ServiceOrder.create!(status: 'rejected', package: Package.new)
    ServiceOrder.create!(status: 'pending', package: Package.new)
    ServiceOrder.create!(status: 'accepted', package: Package.new)
    ServiceOrder.create!(status: 'delivered', package: Package.new)

    visit root_path
    click_on 'Ordens de Serviço'

    expect(current_path).to eq service_orders_path
    expect(page).to have_text('Ordens de Serviço')
    expect(page).to have_css('.unassigned', text: 'Novas')
    within '.unassigned' do
      expect(page).to have_text('ID: 2 | detalhes')
      expect(page).to have_link('detalhes')
    end
  end

  it 'see rejected service orders' do
    ServiceOrder.create!(status: 'rejected', package: Package.new)

    visit service_orders_path

    expect(page).to have_css('.rejected', text: 'Devolvidas')
    within '.rejected' do
      expect(page).to have_text('ID: 1 | detalhes')
    end
  end

  it 'sees nothing because there are no new or reject orders' do
    visit service_orders_path
     expect(page).to have_text('Nenhuma ordem de serviço nova')
     expect(page).to have_text('Nenhuma ordem de serviço devolvida')
  end
end