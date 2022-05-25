class ServiceOrdersController < ApplicationController
  def index
    @unassigned_orders = ServiceOrder.where(status: 'unassigned')
    @rejected_orders = ServiceOrder.where(status: 'rejected')
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
    @package = @service_order.package
    @measures = [@package.width_in_cm, @package.length_in_cm, @package.height_in_cm].sort.reverse
    @quotes = @service_order.get_quotes
  end
end