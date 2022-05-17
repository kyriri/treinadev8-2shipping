require 'rails_helper'

describe 'User attempts sign-in' do
  it 'succesfully' do
    User.create!(email: 'me@email.com', password: '12345678')
    
    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'me@email.com'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
    expect(page).to have_css(nav, text: 'me@email.com')
  end
end