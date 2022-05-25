require 'rails_helper'

describe 'Unlogged user visits the application and' do
  it 'is redirected to login page' do
    visit '/shipping_companies/2'

    expect(current_path).to eq new_user_session_path
  end

  it 'is redirected to the desired page after login' do
    User.create!(email: 'me@email.com', password: '12345678')

    visit service_orders_path
    fill_in 'Email', with: 'me@email.com'
    fill_in 'Senha', with: '12345678'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq service_orders_path
  end
end