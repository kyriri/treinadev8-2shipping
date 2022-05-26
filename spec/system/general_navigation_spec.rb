require 'rails_helper'

describe 'Unlogged user lands on homepage and' do
  it 'see application name' do
    visit '/'

    expect(page).to have_css('header', text: 'East Wing - Departamento de Envios')
  end
end

xdescribe 'Admin lands on homepage and' do
  it 'can reach area for Shipping Companies' do
    visit root_path
    click_on 'Transportadoras'

    expect(current_path).to eq(shipping_companies_path)
  end

  #TODO check button 'Voltar' on Shipping Company details page when user is logged in
end