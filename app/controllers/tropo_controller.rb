class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'

  # POST /tropo.json
  def index

    begin

      data = JSON.parse(request.raw_post)
      logger.info "JSON parsed response data: " + data

      numbertodial = "+" + data[:session][:parameters][:numbertodial]
      logger.info "JSON numbertodial: " + numbertodial.to_s

      msg = data[:session][:parameters][:msg]
      logger.info "JSON msg: " + msg.to_s

      id = data[:session][:parameters][:customername]
      logger.info "JSON id: " + id.to_s

      t = Tropo::Generator.new()
      t.call(:from => PROD_PHONE_NUMBER, :to => numbertodial, :network => 'SMS', :name => id)
      t.say(:value => msg, :name => id)

    rescue Exception => error_msg
      logger.error error_msg
    end

    render status: 200, json:  t.response

  end

end