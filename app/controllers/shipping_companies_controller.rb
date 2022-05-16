class ShippingCompaniesController < ApplicationController
  before_action :find_shipping_co, only: [:show, :edit, :update, :fake_delete]

  def index
    @shipping_cos = ShippingCompany.where.not(status: :deleted).order('name')
  end

  def show
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
    @statuses = form_statusus
  end

  def update
    if @shipping_co.update(shipping_co_params)
      flash[:notice] = t('shipping_company_update_succesful')
      redirect_to @shipping_co
    else
      flash.now[:alert] = t('shipping_company_update_failed')
      @statuses = form_statusus
      render :edit
    end
  end

  def fake_delete
    if @shipping_co.update(status: 'deleted')
      flash[:notice] = t('shipping_company_fakedelete_succesful', name: @shipping_co.name)
      redirect_to shipping_companies_path
    else
      flash[:alert] = t('shipping_company_fakedelete_failed')
      redirect_to @shipping_co
    end
  end

  private

  def shipping_co_params
    params.require(:shipping_company).permit(:name, :status, :legal_name,
                                            :cnpj, :email_domain, :billing_address)
  end

  def find_shipping_co
    @shipping_co = ShippingCompany.find(params[:id])
  end

  def form_statusus
    Hash[ ShippingCompany.statuses
      .select { |k,v| k != "deleted" }
      .map { |k,v| [k, ShippingCompany.human_attribute_name("status.#{k}")] }
    ]
  end
end