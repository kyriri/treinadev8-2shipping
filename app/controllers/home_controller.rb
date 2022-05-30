class HomeController < ApplicationController
  def index
    @number_unassigned_packages = ServiceOrder.unassigned.count
    @number_pending_packages = ServiceOrder.pending.count
    @number_rejected_packages = ServiceOrder.rejected.count
  end
end