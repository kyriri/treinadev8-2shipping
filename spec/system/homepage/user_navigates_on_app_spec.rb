require 'rails_helper'

describe 'User logs in and' do
  context 'their home page' do
    it 'has a navbar with certain links' do
      user = User.create!(email: 'me@email.com', password: '12345678')

      login_as(user)
      visit root_path

      within 'nav' do
        expect(page).to have_link('Minha Empresa')
        expect(page).to have_link('Minhas Ordens de Serviço')
        expect(page).to have_link('Meus Preços & Prazos')
        expect(page).to have_link('Meus Entrepostos')
      end
    end
  end

  xcontext 'cannot visit' do
    # service orders not assigned to them
    # details of other shipping companies
    # prices of other shipping companies
    # logistic bases of other company
  end

  xcontext 'can do' do
    # CRUD logistic bases
    # add delivery updates
  end

  xcontext 'cannot do' do
    # delete their own company
  end

  xcontext 'can edit their own company details' do
    it 'succesfully' do
    end

    it 'but not its status' do
    end
  end
end

describe 'Admin logs in and' do
  context 'their home page' do
    it 'has a navbar with certain links' do
      admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

      login_as(admin)
      visit root_path

      within 'nav' do
        expect(page).to have_link('Transportadoras')
        expect(page).to have_link('Ordens de Serviço')
      end
    end
  end
end