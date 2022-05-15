class ShippingCompanyController < ApplicationController
  def index
    @shipping_cos = ShippingCompany.order('name')
  end
end