require 'rails_helper'

RSpec.describe ServiceOrder, type: :model do
  context '#get_quotes' do
    it 'only considers active companies' do
      sc1 = ShippingCompany.create!(status: 'deleted', name: 'Transportes Marília', legal_name: 'Transportes Marília Ltda', email_domain: 'tma.com.br', cnpj: 12345678904321, billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
      sc2 = ShippingCompany.create!(status: 'active', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      sc3 = ShippingCompany.create!(status: 'active', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
      sc4 = ShippingCompany.create!(status: 'in_registration', name: 'Granelero', legal_name: 'Transportes Graneleros do Brasil S.A.', email_domain: 'br.granelero.com', cnpj: 34259054000134, billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
      s_o = ServiceOrder.create!(package: Package.new)

      results = s_o.get_quotes
      companies_answering = results.map { |q| q.shipping_company_id }

      expect(results.size).to be 2
      expect(companies_answering).to eq [2, 3]
    end

    it 'returns error message if there are no active companies' do
      sc1 = ShippingCompany.create!(status: 'deleted', name: 'Transportes Marília', legal_name: 'Transportes Marília Ltda', email_domain: 'tma.com.br', cnpj: 12345678904321, billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
      sc2 = ShippingCompany.create!(status: 'suspended', name: 'Cheirex', legal_name: 'Transportes Federais do Brasil S.A.', email_domain: 'cheirex.com', cnpj: 12345678901234, billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')
      sc3 = ShippingCompany.create!(status: 'in_registration', name: 'Ibérica', legal_name: 'Ibérica dos Transportes Ltda', email_domain: 'iberica.com.br', cnpj: 98765432101234, billing_address: 'Rua da Paz, 34 - Rio Branco, AC')
      s_o = ServiceOrder.create!(package: Package.new)

      results = s_o.get_quotes

      expect(results).to eq []
    end
  end

  context '#select_carriers_with_best' do
    it 'fee finds all the cheapest carriers' do
      s_o = ServiceOrder.new
      quotes = [ { company_id: 1, package_id: 32, fee: 15.50, delivery_time: 2 }, 
                 { company_id: 2, package_id: 32, fee: 7.23, delivery_time: 5 }, 
                 { company_id: 5, package_id: 32, fee: 8, delivery_time: 7 }, 
                 { company_id: 76, package_id: 32, fee: 7.23, delivery_time: 4 },
               ]

      filtered_quotes = s_o.select_carriers_with_best(:fee, quotes)
      range_of_values = [filtered_quotes.map { |q| q[:fee] }.min, filtered_quotes.map { |q| q[:fee] }.max]
      selected_companies = filtered_quotes.map { |q| q[:company_id] }

      expect(filtered_quotes.length).to be 2
      expect(range_of_values.first).to be 7.23
      expect(range_of_values.last).to be 7.23
      expect(selected_companies).to eq([2, 76])
    end

    it 'delivery time finds all the fastest carriers' do
      s_o = ServiceOrder.new
      quotes = [ { company_id: 1, package_id: 32, fee: 15.50, delivery_time: 2 }, 
                 { company_id: 2, package_id: 32, fee: 7.23, delivery_time: 2 }, 
                 { company_id: 5, package_id: 32, fee: 8, delivery_time: 2 }, 
                 { company_id: 33, package_id: 32, fee: 7.23, delivery_time: 4 },
               ]

      filtered_quotes = s_o.select_carriers_with_best(:delivery_time, quotes)
      range_of_values = [filtered_quotes.map { |q| q[:delivery_time] }.min, filtered_quotes.map { |q| q[:delivery_time] }.max]
      selected_companies = filtered_quotes.map { |q| q[:company_id] }

      expect(filtered_quotes.length).to be 3
      expect(range_of_values.first).to be 2
      expect(range_of_values.last).to be 2
      expect(selected_companies).to eq([1, 2, 5])
    end

    it 'works with a single quote' do
      s_o = ServiceOrder.new
      quotes = [ { company_id: 1, package_id: 32, fee: 15.50, delivery_time: 2 } ]
      
      filtered_quotes = s_o.select_carriers_with_best(:fee, quotes)

      expect(quotes).to eq filtered_quotes
    end

    it 'return an error message if no quotes are passed' do #TODO populate the error object for flash messages
      s_o = ServiceOrder.new
      quotes = []
      
      filtered_quotes = s_o.select_carriers_with_best(:fee, quotes)

      expect(filtered_quotes).to eq 'Unable to choose best quote from an empty list'
    end
  end
end
