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

  xcontext 'when done by an admin' do
    it 'returns results for any company' do
    end
  end

  context 'when done by a shipping company user' do
    it 'returns one exact result for their own company' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
      ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
      ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc)
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

      login_as(user)
      visit root_path
      find('#search').fill_in 'Ordem de serviço:', with: '3'
      click_on 'Buscar'

      expect(page).to have_text('Resultados da busca por: 3')
      expect(page).to have_text('1 resultado encontrado')
      expect(page).to have_text('Ordem de serviço nº 3 | aguardando confirmação | detalhes')
      expect(page).to have_link('detalhes', href: service_order_path(id: 3, locale: :'pt-BR'))
      expect(page).not_to have_link('detalhes', href: service_order_path(id: 1, locale: :'pt-BR'))
    end

    it 'returns multiple results for their own company' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      11.times { ServiceOrder.create!(status: 'pending', package: Package.new, shipping_company: sc) }
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

      login_as(user)
      visit root_path
      find('#search').fill_in 'Ordem de serviço:', with: '1'
      click_on 'Buscar'

      expect(page).to have_text('Resultados da busca por: 1')
      expect(page).to have_text('3 resultados encontrados')
      expect(page).to have_text('Ordem de serviço nº 1')
      expect(page).to have_text('Ordem de serviço nº 10')
      expect(page).to have_text('Ordem de serviço nº 11')
      expect(page).not_to have_text('Ordem de serviço nº 2')

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

    it 'can also be done using the delivery code' do
      sc = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cubic_weight_const: 35, min_fee: 8)
      Delivery.create!(tracking_code: 'HU000000000BR', service_order: ServiceOrder.new(shipping_company: sc, package: Package.new, status: 'accepted'))
      Delivery.create!(tracking_code: 'HU876592369PL', service_order: ServiceOrder.new(shipping_company: sc, package: Package.new, status: 'accepted'))
      Delivery.create!(tracking_code: 'YP876592369BR', service_order: ServiceOrder.new(shipping_company: sc, package: Package.new, status: 'delivered'))
      another_sc = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC', min_fee: 10)
      another_delivery = Delivery.create!(tracking_code: 'another_companyGT00375BR', service_order: ServiceOrder.new(shipping_company: another_sc, package: Package.new, status: 'accepted'))
      user = User.create!(email: 'me@email.com', password: '12345678', shipping_company: sc)

      login_as(user)
      visit root_path
      find('#search').fill_in 'Ordem de serviço:', with: 'br'
      click_on 'Buscar'

      expect(page).to have_text('Resultados da busca por: br')
      expect(page).to have_text('Ordem de serviço nº 1 | aceita | código de rastreio: HU000000000BR | detalhes')
      expect(page).to have_text('Ordem de serviço nº 3 | entregue | código de rastreio: YP876592369BR | detalhes')
      expect(page).not_to have_text('Ordem de serviço nº 2')
      expect(page).not_to have_text('HU876592369PL')
      expect(page).not_to have_text('Ordem de serviço nº 4')
      expect(page).not_to have_text('another_companyGT00375BR')
    end
  end
end