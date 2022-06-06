class ShippingRatesController < ApplicationController
  before_action :verify_user_and_rates_are_from_same_company, only: [:index]
  
  def index
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @shipping_rates = @shipping_company.shipping_rates.order(:max_weight_in_kg)
    @delivery_times = @shipping_company.delivery_times.order(:max_distance_in_km)
  end

  def edit
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
  end

  # since the form is a nestled one, the "update" action is actually managed by the shipping company controller
  
  private

  def verify_user_and_rates_are_from_same_company
    unless current_user.admin?
      if current_user.shipping_company != ShippingCompany.find(params[:shipping_company_id])
        return redirect_to root_path, alert: t('shipping_company_auth_error')
      end
    end 
  end
end