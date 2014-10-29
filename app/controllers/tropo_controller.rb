class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'

  # POST /tropo.json
  def index

    t = Tropo::Generator.new()

    begin

      data = JSON.parse(request.raw_post)

      if (params[:continue] == "true")

        logger.info "=== GOT POST REQUEST FROM TROPO FOR RESPOND ON SMS MESSAGE ==="

        #answer = data[:result][:actions][:color][:value]
        t.say(:value => "Thank you!")

      else

        logger.info "=== GOT POST REQUEST FROM TROPO TO SEND SMS MESSAGE ==="


        numbertodial = data['session']['parameters']['numbertodial']
        msg = data['session']['parameters']['msg']
        id = data['session']['parameters']['customername']

        t.call(:from => PROD_PHONE_NUMBER, :to => "+" + numbertodial, :network => 'SMS', :name => id)

        t.ask :name => 'color',
              :timeout => 60,
              :say => {:value => "What's your favorite color?  Choose from red, blue or green."},
              :choices => {:value => "red, blue, green"}

        t.on :event => 'continue', :next => '/tropo?continue=true'

      end

    rescue Exception => error_msg
      logger.error error_msg
    end

    render json: t.response

  end

end