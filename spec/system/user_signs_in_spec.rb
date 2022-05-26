require 'rails_helper'

describe 'User signs in' do
  it 'succesfully' do
    User.create!(email: 'me@email.com', password: '12345678')
    
    visit root_path
    within 'form' do
      fill_in 'Email', with: 'me@email.com'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end

    expect(page).to have_text('Login efetuado com sucesso')
    expect(page).to have_css('header', text: 'me@email.com')
    expect(page).not_to have_link('Entrar')
    expect(page).to have_button('Sair')
  end

  it 'and then signs out' do
    User.create!(email: 'me@email.com', password: '12345678')
    
    visit new_user_session_path
    within 'form' do
      fill_in 'Email', with: 'me@email.com'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_css('header', text: 'me@email.com')
    expect(page).to have_link('Entrar')
    expect(page).not_to have_link('Sair')
  end
end