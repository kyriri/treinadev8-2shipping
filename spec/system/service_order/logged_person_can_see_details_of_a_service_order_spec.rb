require 'rails_helper'

describe 'Logged person visits details of a service order' do
  it 'succesfully' do
    s_o = ServiceOrder.create!(status: 'unassigned', package: Package.new)

    visit service_orders_path
    click_on 'detalhes'

    expect(page).to have_text('Ordem de serviço nº 1')
    expect(current_path).to eq service_order_path(s_o)
  end
end