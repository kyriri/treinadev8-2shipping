class OutpostsController < ApplicationController
  before_action :verify_user_and_outposts_are_from_same_company, only: [:index]
  
  def index
    shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @outposts = shipping_company.outposts.where(standard: false).order(:city_state)
  end
  
  private

  def verify_user_and_outposts_are_from_same_company # TODO make DRYer this code and the equivalent from Shipping Rates
    unless current_user.admin?
      if current_user.shipping_company != ShippingCompany.find(params[:shipping_company_id])
        return redirect_to root_path, alert: t('shipping_company_auth_error')
      end
    end 
  end
end