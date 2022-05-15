class ShippingCompanyController < ApplicationController
  def index
    @shipping_cos = ShippingCompany.order('name')
  end

  def show
    @shipping_co = ShippingCompany.find(params[:id])
  end
end