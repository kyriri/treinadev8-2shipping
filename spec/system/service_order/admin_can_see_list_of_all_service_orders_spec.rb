require 'rails_helper'

describe 'Admin can see a list of all service orders' do
  it 'succesfully' do
    visit root_path
    click_on 'Ordens de Serviço'

    expect(page).to have_text('Ordens de Serviço')
    expect(current_path).to eq service_orders_path
  end
end