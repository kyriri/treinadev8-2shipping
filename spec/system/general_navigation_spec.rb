require 'rails_helper'

describe 'Unlogged user lands on homepage and' do
  it 'see application name' do
    visit '/'

    expect(page).to have_css('nav', text: 'East Wing - Shipping')
  end
end