require 'rails_helper'

describe 'Logged user visits homepage' do
  context 'as an admin' do
    it 'and sees a summary of packages awaiting handling' do
      admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)
      so1 = ServiceOrder.create!(status: 1, package: Package.new)
            ServiceOrder.create!(status: 1, package: Package.new)
            ServiceOrder.create!(status: 1, package: Package.new)
      so3 = ServiceOrder.create!(status: 3, package: Package.new)
            ServiceOrder.create!(status: 3, package: Package.new)
      so5 = ServiceOrder.create!(status: 5, package: Package.new)

      login_as(admin)
      visit root_path

      expect(so1.status).to eq('unassigned') 
      expect(so3.status).to eq('rejected') 
      expect(so5.status).to eq('pending') 
      expect(page).to have_text('Encomendas novas (sem ordem de serviço): 3')
      expect(page).to have_text('Encomendas rejeitadas por transportadoras: 2')
      expect(page).to have_text('Encomendas pendentes de resposta da transportadora: 1')
    end

    it "doesn't see a summary because no packages are awaiting handling" do
      admin = User.create!(email: 'me@email.com', password: '12345678', admin: true)

      login_as(admin)
      visit root_path

      expect(page).not_to have_text('Encomendas novas (sem ordem de serviço)')
      expect(page).not_to have_text('Encomendas rejeitadas por transportadoras')
      expect(page).not_to have_text('Encomendas pendentes de resposta da transportadora')
    end
  end

  xcontext 'as a normal user' do # TODO homepage for normal users 
    it 'and sees a summary of service orders to accept/reject' do
      user = User.create!(email: 'me@email.com', password: '12345678')

      login_as(user)
    end
  end
end