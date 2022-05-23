require 'rails_helper'

describe 'Admin visits homepage and' do
  it 'sees a summary of packages awaiting shipment' do
    so1 = ServiceOrder.create!(status: 1, package: Package.new)
          ServiceOrder.create!(status: 1, package: Package.new)
          ServiceOrder.create!(status: 1, package: Package.new)
    so3 = ServiceOrder.create!(status: 3, package: Package.new)
          ServiceOrder.create!(status: 3, package: Package.new)
    so5 = ServiceOrder.create!(status: 5, package: Package.new)
                  
    visit root_path

    expect(so1.status).to eq('unassigned') 
    expect(so3.status).to eq('rejected') 
    expect(so5.status).to eq('pending') 
    expect(page).to have_text('Encomendas novas (sem ordem de serviço): 3')
    expect(page).to have_text('Encomendas rejeitadas por transportadoras: 2')
    expect(page).to have_text('Encomendas pendentes de resposta da transportadora: 1')
  end

  it "doesn't see a summary because no packages are awaiting shipment" do
    visit root_path

    expect(page).not_to have_text('Encomendas novas (sem ordem de serviço)')
    expect(page).not_to have_text('Encomendas rejeitadas por transportadoras')
    expect(page).not_to have_text('Encomendas pendentes de resposta da transportadora')
  
  end
end