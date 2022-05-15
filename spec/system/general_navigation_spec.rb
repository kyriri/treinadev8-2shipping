require 'rails_helper'

describe 'Unlogged user lands on homepage and' do
  it 'see application name' do
    visit '/'

    expect(page).to have_css('nav', text: 'East Wing - Shipping')
  end
end

describe 'Admin lands on homepage and' do
  it 'can reach area for Shipping Companies' do
    visit root_path
    click_on 'Transportadoras'

    expect(current_path).to eq(shipping_companies_path)
  end
end