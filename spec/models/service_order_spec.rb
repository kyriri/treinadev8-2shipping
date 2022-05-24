require 'rails_helper'

RSpec.describe ServiceOrder, type: :model do
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
  end
end
