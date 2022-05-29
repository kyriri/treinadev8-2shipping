class OutpostsController < ApplicationController
  before_action :verify_user_and_outposts_are_from_same_company, only: [:index]
  
  def index
    shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @outposts = shipping_company.outposts.order(:city_state)
  end

  def new
    shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @outpost = Outpost.new(shipping_company: shipping_company)
  end

  def create
    outpost_params = params.require(:outpost).permit(:name, :city_state, :category)
    outpost_params.merge!({ shipping_company_id: params[:shipping_company_id] })
    @outpost = Outpost.new(outpost_params)
    if @outpost.save
      redirect_to shipping_company_outposts_path(@outpost.shipping_company), notice: t('.success', name: @outpost.name)
    else
      flash.now[:alert] = t('.error')
      render :new 
    end
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