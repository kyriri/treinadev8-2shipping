require 'rails_helper'

feature 'Search for service orders' do
  it 'is available from the navbar' do
    user = User.create!(email: 'me@email.com', password: '12345678')

    login_as(user)
    visit root_path

    within 'nav' do
      expect(page).to have_css('input#query')
    end
  end

  it 'is not available for unlogged users' do
    visit root_path

    expect(page).not_to have_css('input#query')
  end

  xit "doesn't consider symbols" do
  end

  xit 'strips whitespaces' do
  end

  xit 'chomps multiline indicators' do
  end

  xcontext 'when done by an admin' do
    it 'returns results for any company' do
    end
  end

  context 'when done by a shipping company user' do
    it 'returns results for their own company' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
      ServiceOrder.create!(status: 'accepted', package: Package.new, shipping_company: sc)
      ServiceOrder.create!(status: 'delivered', package: Package.new, shipping_company: sc)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

      login_as(user)
      visit root_path
      find('#search').fill_in 'Ordem de serviço:', with: '3'
      click_on 'Buscar'

      expect(page).to have_text('Resultados da busca por: 3')
      expect(page).to have_text('Ordem de serviço nº 3 | entregue | detalhes')
      expect(page).to have_link('detalhes', href: service_order_path(id: 3, locale: :'pt-BR'))
      expect(page).not_to have_link('detalhes', href: service_order_path(id: 1, locale: :'pt-BR'))
    end

    it 'ignores results of other companies' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
      ServiceOrder.create!(status: 'accepted', package: Package.new, shipping_company: sc)
      user = User.create!(email: 'me@email.com', password: '12345678')

      login_as(user)
      visit root_path
      find('#search').fill_in 'Ordem de serviço:', with: '2'
      click_on 'Buscar'

      expect(page).to have_text('Nenhum resultado encontrado')
      expect(page).not_to have_link('detalhes', href: service_order_path(id: 2, locale: :'pt-BR'))
    end
  end
end