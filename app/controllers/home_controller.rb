class HomeController < ApplicationController
  def index
    @number_unassigned_packages = ServiceOrder.where(status: 'unassigned').count
    @number_pending_packages = ServiceOrder.where(status: 'pending').count
    @number_rejected_packages = ServiceOrder.where(status: 'rejected').count
  end
end