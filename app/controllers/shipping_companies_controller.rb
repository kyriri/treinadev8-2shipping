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
    flash[:alert] = 'Entered create'
  end
end