class ServiceOrdersController < ApplicationController
  before_action :verify_user_and_order_are_from_same_company, only: [:show]

  def index
    @building_blocks = get_building_blocks
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
    @package = @service_order.package
    @measures = [@package.width_in_cm, @package.length_in_cm, @package.height_in_cm].sort.reverse
    @outposts = @service_order.shipping_company.outposts.where(deleted_at: nil).order(:city_state) if @service_order.shipping_company
    @delivery_stages = @service_order.delivery.stages.order(created_at: :desc) if @service_order.delivery
    if current_user.admin?
      return @quotes = [] if @service_order.quotes.empty?
      newest_quote_group = @service_order.quotes.order(created_at: :desc).first.quote_group
      @quotes = @service_order.quotes.where(quote_group: newest_quote_group)
    else
      @winning_quote = @service_order.quotes.where(chosen: true, shipping_company: @service_order.shipping_company).order(:created_at).last
    end
  end

  def search
    @original_query = params[:query]
    search_queries = @original_query.match(/(\w+)/).present? ? @original_query.match(/(\w+)/).captures : []
    @service_orders = search_queries.reduce([]) { |memo, query|
      if current_user.admin
        memo << ServiceOrder.where('id LIKE ?', "%#{query}%")
        memo << ServiceOrder.joins(:delivery).where('tracking_code LIKE ?', "%#{query}%")
      else
        memo << ServiceOrder.where(shipping_company: current_user.shipping_company).where('id LIKE ?', "%#{query}%")
        memo << ServiceOrder.where(shipping_company: current_user.shipping_company).joins(:delivery).where('tracking_code LIKE ?', "%#{query}%")
      end
    }.flatten
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

  def attribute_to_carrier
    service_order = ServiceOrder.find(params[:id])
    quote = Quote.find(params[:quote])
    shipping_company = ShippingCompany.find(params[:carrier])
    service_order.shipping_company = shipping_company
    service_order.pending!
    quote.chosen = true
    quote.save!
    redirect_to service_order, notice: "Ordem de serviço enviada para #{shipping_company.name}"
  end

  def update_status
    service_order = ServiceOrder.find(params[:id])
    new_status = params[:status]
    service_order.create_delivery if new_status == 'accepted'
    service_order.status = new_status
    service_order.save!
    redirect_to service_orders_path, notice: "A ordem foi #{ServiceOrder.human_attribute_name("status.#{service_order.status}")} com sucesso."
  end

  private
  
  def verify_user_and_order_are_from_same_company # TODO test this
    unless current_user.admin?
      if current_user.shipping_company != ServiceOrder.find(params[:id]).shipping_company
        return redirect_to root_path, alert: t('shipping_company_auth_error')
      end
    end 
  end

  def get_building_blocks
    if current_user.admin?
      [{ title: t('.new_orders'),
        css_class: 'unassigned',
        collection: ServiceOrder.unassigned,
      }, {
        title: t('.rejected'),
        css_class: 'rejected',
        collection: ServiceOrder.rejected,
      }, {
        title: t('.delivered'),
        css_class: 'delivered',
        collection: ServiceOrder.delivered,
      }]
    else
      company = ShippingCompany.find(current_user.shipping_company.id)
      [{ title: t('.new_orders'),
        css_class: 'pending',
        collection: ServiceOrder.where(shipping_company_id: company.id).pending,
      }, {
        title: t('.being_delivered'),
        css_class: 'accepted',
        collection: ServiceOrder.where(shipping_company_id: company.id).accepted,
      }, {
        title: t('.delivered'),
        css_class: 'delivered',
        collection: ServiceOrder.where(shipping_company_id: company.id).delivered,
      }]
    end
  end
end