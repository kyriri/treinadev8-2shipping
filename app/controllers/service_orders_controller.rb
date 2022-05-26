class ServiceOrdersController < ApplicationController
  def index
    if current_user.admin?
      @building_blocks = [{ title: 'Novas',
                            css_class: 'unassigned',
                            collection: ServiceOrder.where(status: 'unassigned'),
                          }, {
                            title: 'Devolvidas',
                            css_class: 'rejected',
                            collection: ServiceOrder.where(status: 'rejected'),
                          }]
    else
      company = ShippingCompany.find(current_user.shipping_company.id)
      @building_blocks = [{ title: 'Novas',
                            css_class: 'pending',
                            collection: ServiceOrder.where(shipping_company_id: company.id).pending,
                          }, {
                            title: 'Em processo de entrega',
                            css_class: 'accepted',
                            collection: ServiceOrder.where(shipping_company_id: company.id).accepted,
                          }]
    end
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
    @package = @service_order.package
    @measures = [@package.width_in_cm, @package.length_in_cm, @package.height_in_cm].sort.reverse
    @quotes = @service_order.get_quotes
  end
end