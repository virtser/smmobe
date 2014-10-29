class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'

  # POST /tropo.json
  def index

    t = Tropo::Generator.new()

    begin

      data = JSON.parse(request.raw_post)
      logger.info request.raw_post

      if (params[:continue] == "true")

        logger.info "=== GOT POST REQUEST FROM TROPO FOR RESPOND ON SMS MESSAGE ==="

        #answer = data[:result][:actions][:color][:value]
        #numbertodial = data['result']['calledid']
        #t.call(:from => PROD_PHONE_NUMBER, :to => "+" + numbertodial, :network => 'SMS')
        #t.say(:value => "Thank you!")

      else

        if (data['session']['initialText'].nil?)

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


        else

          logger.info "=== GOT POST REQUEST FROM TROPO ON SMS MESSAGE REPLY ==="

          numbertodial = data['session']['from']['id']
          answer = data['session']['initialText']
          t.call(:from => PROD_PHONE_NUMBER, :to => "+" + numbertodial, :network => 'SMS')
          t.say(:value => "You answered: " + answer)

        end

      end

    rescue Exception => error_msg
      logger.error error_msg
    end

    logger.info "=== SENDING RESPONSE TO TROPO ==="
    render json: t.response

  end

end