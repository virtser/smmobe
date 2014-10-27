class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'

  # POST /tropo.json
  def index

    data = JSON.parse(request.raw_post)
    logger.info "JSON parsed response data: " + data

    numbertodial = data[:session][:parameters][:numbertodial]
    logger.info "JSON numbertodial: " + numbertodial

    msg = data[:session][:parameters][:msg]
    logger.info "JSON msg: " + msg

    id = data[:session][:parameters][:customername]
    logger.info "JSON id: " + id

    t = Tropo::Generator.new()
    t.call(:from => PROD_PHONE_NUMBER, :to => numbertodial, :network => 'SMS', :name => id)
    t.say(:value => msg, :name => id)

    render :json =>  t.response

  end

end