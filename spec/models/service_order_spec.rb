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

      filtered = s_o.select_carriers_with_best(:fee, quotes)

      expect(filtered.length).to be 2
      expect(filtered[0][:fee]).to be 7.23
      expect(filtered[0][:company_id]).to be 2
      expect(filtered[1][:fee]).to be 7.23
      expect(filtered[1][:company_id]).to be 76
    end
  end

  context '#select_carriers_with_best' do
    it 'delivery time finds all the fastest carriers' do
      s_o = ServiceOrder.new
      quotes = [ { company_id: 1, package_id: 32, fee: 15.50, delivery_time: 2 }, 
                 { company_id: 2, package_id: 32, fee: 7.23, delivery_time: 2 }, 
                 { company_id: 5, package_id: 32, fee: 8, delivery_time: 2 }, 
                 { company_id: 33, package_id: 32, fee: 7.23, delivery_time: 4 },
               ]

      filtered = s_o.select_carriers_with_best(:delivery_time, quotes)

      expect(filtered.length).to be 3
      expect(filtered[0][:delivery_time]).to be 2
    end
  end
end
