class ShippingCompaniesController < ApplicationController
  before_action :find_shipping_co, only: [:show, :edit, :update, :fake_delete]
  before_action :auth_admin, only: [:index, :new, :create, :fake_delete]
  before_action :verify_user_is_from_the_target_company, only: [:show, :edit, :update]

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
    @statuses = form_statuses
  end

  def update
    shipping_co_params.delete(:status) unless current_user.admin? # TODO test this line
    
    if params[:shipping_company][:shipping_rates_attributes].present?
      # shipping rates edit
      rates_params = params.require(:shipping_company).permit(shipping_rates_attributes: [:id, :cost_per_km_in_cents])
      rates_params[:shipping_rates_attributes].each do |index, rate_params|
        @rate = ShippingRate.find(rate_params[:id])
        @rate.cost_per_km_in_cents = rate_params[:cost_per_km_in_cents]
        unless @rate.save
          @shipping_company = ShippingCompany.find(params[:id])
          flash.now[:alert] = t('shipping_rates.edit.flash_error')
          render 'shipping_rates/edit'
          return
        end
      end
      redirect_to shipping_company_shipping_rates_path(@shipping_co), notice: t('shipping_rates.edit.flash_success')
    else
      # shipping company edit
      if @shipping_co.update(shipping_co_params)
        flash[:notice] = t('shipping_company_update_succesful')
        redirect_to @shipping_co
      else
        flash.now[:alert] = t('shipping_company_update_failed')
        @statuses = form_statuses
        render :edit
      end
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
                                            :cnpj, :email_domain, :billing_address,
                                            :cubic_weight_const, :min_fee,
                                            )
  end

  def find_shipping_co
    @shipping_co = ShippingCompany.find(params[:id])
  end

  def form_statuses
    Hash[ ShippingCompany.statuses
      .select { |k,v| k != "deleted" }
      .map { |k,v| [k, ShippingCompany.human_attribute_name("status.#{k}")] }
    ]
  end

  def auth_admin
    redirect_to root_path, alert: t('shipping_company_auth_error') unless current_user.admin?
  end

  def verify_user_is_from_the_target_company
    unless current_user.admin?
      if current_user.shipping_company != @shipping_co
        return redirect_to root_path, alert: t('shipping_company_auth_error')
      end
    end 
  end
end