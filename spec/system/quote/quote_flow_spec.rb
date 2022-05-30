require 'rails_helper'

describe 'Admin get quotes, chooses one' do
    it 'and that information arrives to the user' do
      sc1 = ShippingCompany.create!(status: 'active', cubic_weight_const: 100, min_fee: 33.33, name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP', cnpj: 12345678901234)
            ShippingRate.create!(shipping_company: sc1, max_weight_in_kg: 2, cost_per_km_in_cents: 60)
            DeliveryTime.create!(shipping_company: sc1, max_distance_in_km: 550, delivery_time_in_buss_days: 2)
      sc2 = ShippingCompany.create!(status: 'active', cubic_weight_const: 300, min_fee: 10, name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
            ShippingRate.create!(shipping_company: sc2, max_weight_in_kg: 3, cost_per_km_in_cents: 55)
            DeliveryTime.create!(shipping_company: sc2, max_distance_in_km: 1_000, delivery_time_in_buss_days: 8)
      package = Package.new(distance_in_km: 50, weight_in_g: 1_000, volume_in_m3: 0.005)
      serv_order = ServiceOrder.create!(status: 'unassigned', package: package)
      user = User.create!(email: 'user@email.com', password: '123456', shipping_company: sc1)
      admin = User.create!(admin: true, email: 'admin@email.com', password: '123456')
      
      login_as(admin)
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'detalhes'
      click_on 'Obter orçamentos'
      # sc1: cubic weight: 0.005 * 100 = 0.5 kg | weight for calculus: 1 kg   | rate: R$ 0,60/km | fee: 50 * 0.60 = R$ 30    | min fee 33.33 | fee 33.33
      # sc2: cubic weight: 0.005 * 300 = 1.5 kg | weight for calculus: 1.5 kg | rate: R$ 0,55/km | fee: 50 * 0.55 = R$ 27,50 | min fee 10    | fee: 27.5
      within "tr[data-carrier='#{sc1.id}']" do
        click_on 'escolher'
      end
      click_on 'Sair'
      click_on 'Entrar'
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Senha', with: '123456'
      find('form').click_on 'Entrar'
      click_on 'Minhas Ordens de Serviço'
      click_on 'detalhes'

      expect(page).to have_text('R$ 33,33')
      expect(page).to have_text('2 dias úteis')
    end
  end