class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'

  # POST /tropo.json
  def index

    begin

      logger.info "=== GOT POST REQUEST FROM TOPO ==="
      logger.info request.raw_post

      data = JSON.parse(request.raw_post)

      numbertodial = data[:session][:parameters][:numbertodial]
      msg = data[:session][:parameters][:msg]
      id = data[:session][:parameters][:customername]

      t = Tropo::Generator.new()
      t.call(:from => PROD_PHONE_NUMBER, :to => "+" + numbertodial, :network => 'SMS', :name => id)
      t.say(:value => msg, :name => id)

    rescue Exception => error_msg
      logger.error error_msg
    end

    render json: t.response

  end

end