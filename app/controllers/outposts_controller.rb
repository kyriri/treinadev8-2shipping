class OutpostsController < ApplicationController
  before_action :verify_user_and_outposts_are_from_same_company, only: [:index]
  
  def index
    shipping_company = ShippingCompany.find(params[:shipping_company_id])
    @outposts = shipping_company.outposts.order(:city_state).where(standard: false, deleted_at: nil)
  end

  def new
    @outpost = Outpost.new(shipping_company_id: params[:shipping_company_id])
    @page_of_origin = params[:page_of_origin]
  end

  def create
    outpost_params = params.require(:outpost).permit(:name, :city_state, :category)
    outpost_params.merge!({ shipping_company_id: params[:shipping_company_id] })
    @outpost = Outpost.new(outpost_params)
    address = params[:outpost][:page_of_origin].present? ? params[:outpost][:page_of_origin] : shipping_company_outposts_path(@outpost.shipping_company)
    if @outpost.save
      redirect_to address, notice: t('.success', name: @outpost.name)
    else
      flash.now[:alert] = t('.error')
      render :new 
    end
  end

  def destroy
    outpost = Outpost.find(params[:id])
    if outpost.update_attribute(:deleted_at, Time.now)
    redirect_to shipping_company_outposts_path(params[:shipping_company_id]), notice: t('.success', name: "#{outpost.name} - #{outpost.city_state}")
    else
      redirect_to shipping_company_outposts_path(params[:shipping_company_id]), alert: t('.error')
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