class ShippingRatesController < ApplicationController
  def index
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @fees = @shipping_company.shipping_rates.order(:max_weight_in_kg)
    @times = @shipping_company.delivery_times.order(:max_distance_in_km)
  end
end