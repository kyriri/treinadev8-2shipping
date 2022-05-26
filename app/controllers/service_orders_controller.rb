class ServiceOrdersController < ApplicationController
  before_action :verify_user_and_order_are_from_same_company, only: [:show]

  def index
    @building_blocks = get_building_blocks
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
    @package = @service_order.package
    @measures = [@package.width_in_cm, @package.length_in_cm, @package.height_in_cm].sort.reverse
    @quotes = @service_order.quotes #.sort(:created_at :desc).
  end

  def obtain_quotes
    @service_order = ServiceOrder.find(params[:id])
    @quotes = @service_order.get_quotes
    if @quotes == 'no active companies'
      redirect_to @service_order, alert: 'Não existem transportadoras ativas'
    else
      redirect_to @service_order, notice: 'Rodada de orçamentos obtida com sucesso'
    end
  end

  private

  def verify_user_and_order_are_from_same_company
    unless current_user.admin?
      if current_user.shipping_company != ServiceOrder.find(params[:id]).shipping_company
        return redirect_to root_path, alert: t('shipping_company_auth_error')
      end
    end 
  end

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