class ShippingCompaniesController < ApplicationController
  def index
    @shipping_cos = ShippingCompany.order('name')
  end

  def show
    @shipping_co = ShippingCompany.find(params[:id])
  end

  def new
    @shipping_co = ShippingCompany.new
  end

  def create
    @shipping_co = ShippingCompany.new(shipping_co_params)
    @shipping_co.in_registration!
    if @shipping_co.save
      flash[:notice] = t('shipping_company_registration_succesful')
      redirect_to @shipping_co
    else
      flash[:alert] = t('shipping_company_registration_failed')
      render :new
    end
  end
end

private

def shipping_co_params
  params.require(:shipping_company).permit(:name, :status, :legal_name,
                                           :cnpj, :email_domain, 
                                           :billing_address)
end