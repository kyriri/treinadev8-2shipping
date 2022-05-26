class ServiceOrdersController < ApplicationController
  def index
    if current_user.admin?
      @all_unassigned_orders = ServiceOrder.where(status: 'unassigned')
      @all_rejected_orders = ServiceOrder.where(status: 'rejected')
    else
      @company = ShippingCompany.find(current_user.shipping_company.id)
      @companys_pending_orders = ServiceOrder.where(shipping_company_id: @company.id).pending
      @companys_accepted_orders = ServiceOrder.where(shipping_company_id: @company.id).accepted
    end
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
    @package = @service_order.package
    @measures = [@package.width_in_cm, @package.length_in_cm, @package.height_in_cm].sort.reverse
    @quotes = @service_order.get_quotes
  end
end