require 'rails_helper'

describe 'User requests page' do
  it 'and by default it is in Portuguese' do
    visit root_path

    expect(page).to have_css('header', text: 'Departamento de Envios')
    expect(page).not_to have_text('The requested language is not available. You were redirected to the English version of the website.')
  end

  it 'in Portuguese and sees it in Portuguese' do
    visit '/?locale=pt-BR'

    expect(page).to have_css('header', text: 'Departamento de Envios')
  end

  it 'in English and sees it in English' do
    visit '/users/sign_in/?locale=en'

    expect(page).to have_css('header', text: 'Shipping Department')
  end

  it 'in English even if there is a trailing space' do
    visit '/users/sign_in/?locale=en '

    expect(page).to have_css('header', text: 'Shipping Department')
  end

  it 'in an unsupported language and sees it in English' do
    visit '/users/sign_in/?locale=th'

    expect(page).to have_css('header', text: 'Shipping Department')
    expect(page).to have_text('The requested language is not available. You were redirected to the English version of the website.')
  end
end