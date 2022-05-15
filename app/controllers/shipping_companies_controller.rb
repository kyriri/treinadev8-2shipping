class ShippingCompaniesController < ApplicationController
  def index
    @shipping_cos = ShippingCompany.where.not(status: :deleted).order('name')
  end

  def show
    @shipping_co = ShippingCompany.find(params[:id])
  end

  def new
    @shipping_co = ShippingCompany.new
  end

  def create
    @shipping_co = ShippingCompany.new(shipping_co_params)
    @shipping_co.status = :in_registration
    if @shipping_co.save
      flash[:notice] = t('shipping_company_registration_succesful')
      redirect_to @shipping_co
    else
      flash.now[:alert] = t('shipping_company_registration_failed')
      render :new
    end
  end

  def edit
    @shipping_co = ShippingCompany.find(params[:id])
    @statuses = Hash[ShippingCompany.statuses.map { |k,v| [k, ShippingCompany.human_attribute_name("status.#{k}")] }]
  end

  def update
    @shipping_co = ShippingCompany.find(params[:id])
    @statuses = Hash[ShippingCompany.statuses.map { |k,v| [k, ShippingCompany.human_attribute_name("status.#{k}")] }]

    if @shipping_co.update(shipping_co_params)
      flash[:notice] = t('shipping_company_update_succesful')
      redirect_to @shipping_co
    else
      flash.now[:alert] = t('shipping_company_update_failed')
      render :edit
    end
  end

  def fake_delete
    @shipping_co = ShippingCompany.find(params[:id])
    if @shipping_co.update(status: 'deleted')
      flash[:notice] = t('shipping_company_fakedelete_succesful', name:@shipping_co.name)
      redirect_to shipping_companies_path
    else
      flash[:alert] = t('shipping_company_fakedelete_failed')
      redirect_to @shipping_co
    end
  end

  private

  def shipping_co_params
    params.require(:shipping_company).permit(:name, :status, :legal_name,
                                            :cnpj, :email_domain, 
                                            :billing_address)
  end
end