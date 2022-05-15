class ShippingCompanyController < ApplicationController
  def index
    @shipping_cos = ShippingCompany.all
  end
end