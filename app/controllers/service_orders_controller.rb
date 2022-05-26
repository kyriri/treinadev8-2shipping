class ServiceOrdersController < ApplicationController
  def index
    @building_blocks = get_building_blocks
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
    @package = @service_order.package
    @measures = [@package.width_in_cm, @package.length_in_cm, @package.height_in_cm].sort.reverse
    @quotes = @service_order.get_quotes
  end

  private

  def get_building_blocks
    if current_user.admin?
      [{ title: 'Novas',
        css_class: 'unassigned',
        collection: ServiceOrder.unassigned,
      }, {
        title: 'Devolvidas',
        css_class: 'rejected',
        collection: ServiceOrder.rejected,
      }]
    else
      company = ShippingCompany.find(current_user.shipping_company.id)
      [{ title: 'Novas',
        css_class: 'pending',
        collection: ServiceOrder.where(shipping_company_id: company.id).pending,
      }, {
        title: 'Em processo de entrega',
        css_class: 'accepted',
        collection: ServiceOrder.where(shipping_company_id: company.id).accepted,
      }]
    end
  end
end