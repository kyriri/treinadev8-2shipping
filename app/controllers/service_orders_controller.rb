class ServiceOrdersController < ApplicationController
  def index
    @unassigned_orders = ServiceOrder.where(status: 'unassigned')
    @rejected_orders = ServiceOrder.where(status: 'rejected')
  end
end