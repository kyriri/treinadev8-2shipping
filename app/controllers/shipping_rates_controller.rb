class ShippingRatesController < ApplicationController
  before_action :verify_user_and_rates_are_from_same_company, only: [:index]
  
  def index
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @fees = @shipping_company.shipping_rates.order(:max_weight_in_kg)
    @times = @shipping_company.delivery_times.order(:max_distance_in_km)
  end
  
  private

  def verify_user_and_rates_are_from_same_company
    unless current_user.admin?
      if current_user.shipping_company != ShippingCompany.find(params[:shipping_company_id])
        return redirect_to root_path, alert: t('shipping_company_auth_error')
      end
    end 
  end
end

# TODO issue: admin receives error message login - transportadoras - erro -> actually, error is permanent for admin on shipping company area