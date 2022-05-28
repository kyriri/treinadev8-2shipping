class DeliveriesController < ApplicationController
  def show
    delivery = Delivery.find(params[:id])
    @stages = delivery.stages.order(:when)
    render layout: false
  end

  def add_step
    delivery = Delivery.find(params[:delivery_id])
    outpost = Outpost.find(params[:outpost_id])
    date = Time.now if params[:when].nil? 
    stage = Stage.new(delivery_id: delivery.id, outpost_id: outpost.id, when: date)
    if stage.save
      redirect_to service_order_path(delivery.service_order), notice: 'Passo de entrega cadastrado com sucesso.'
    else
      redirect_to service_order_path(delivery.service_order), alert: 'Houve um erro no cadastro de passo de entrega.'
    end
  end
end 