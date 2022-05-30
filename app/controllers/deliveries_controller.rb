class DeliveriesController < ApplicationController
  def show
    @code = params[:tracking_code]
    @delivery = Delivery.find_by(tracking_code: @code)
    @stages = @delivery.stages.order(:when) unless @delivery.nil?
    render layout: false
  end

  def add_step
    delivery = Delivery.find(params[:delivery_id])
    outpost = Outpost.find(params[:outpost_id])
    date = params[:when] 
    stage = Stage.new(delivery_id: delivery.id, outpost_id: outpost.id, when: date)
    if stage.save
      delivery.service_order.delivered! if stage.outpost.category == 'entregue'
      redirect_to service_order_path(delivery.service_order), notice: 'Passo de entrega cadastrado com sucesso.'
    else
      redirect_to service_order_path(delivery.service_order), alert: 'Houve um erro no cadastro de passo de entrega.'
    end
  end
end 