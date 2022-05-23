require 'rails_helper'

describe 'Admin visits homepage and' do
  it 'sees a summary of service orders awaiting assignment' do
    pack1 = Package.create!(service_order: ServiceOrder.new(status: 1))
            Package.create!(service_order: ServiceOrder.new(status: 1))
            Package.create!(service_order: ServiceOrder.new(status: 1))
    pack3 = Package.create!(service_order: ServiceOrder.new(status: 3))
            Package.create!(service_order: ServiceOrder.new(status: 3))
    pack5 = Package.create!(service_order: ServiceOrder.new(status: 5))
                  
    visit root_path

    expect(pack1.service_order.status).to eq('unassigned') 
    expect(pack3.service_order.status).to eq('rejected') 
    expect(pack5.service_order.status).to eq('pending') 
    expect(page).to have_text('Encomendas novas (sem ordem de serviço): 3')
    expect(page).to have_text('Encomendas rejeitadas por transportadoras: 2')
    expect(page).to have_text('Encomendas pendentes de resposta da transportadora: 1')
  end

  it "doesn't see a summary because no service orders are awaiting assignment" do
    visit root_path

    expect(page).not_to have_text('Encomendas novas (sem ordem de serviço)')
    expect(page).not_to have_text('Encomendas rejeitadas por transportadoras')
    expect(page).not_to have_text('Encomendas pendentes de resposta da transportadora')
  
  end
end