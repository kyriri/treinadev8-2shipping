require 'rails_helper'

describe 'User signs in' do
  it 'succesfully' do
    User.create!(email: 'me@email.com', password: '12345678')
    
    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'Email', with: 'me@email.com'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end

    expect(page).to have_text('Login efetuado com sucesso')
    expect(page).to have_css('nav', text: 'me@email.com')
    expect(page).not_to have_link('Entrar')
    expect(page).to have_button('Sair')
  end

  it 'and then signs out' do
    User.create!(email: 'me@email.com', password: '12345678')
    
    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'Email', with: 'me@email.com'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_text('Logout efetuado com sucesso')
    expect(page).not_to have_css('nav', text: 'me@email.com')
    expect(page).to have_link('Entrar')
    expect(page).not_to have_link('Sair')
  end
end