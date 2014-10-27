class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'

  # POST /tropo.json
  def index

    data = JSON.parse(request.raw_post)
    numbertodial = [:session][:parameters][:numbertodial]
    msg = data[:session][:parameters][:msg]
    id = [:session][:parameters][:customername]

    t = Tropo::Generator.new()
    t.call(:from => PROD_PHONE_NUMBER, :to => '+' + numbertodial, :network => 'SMS', :name => id)
    t.say(:value => msg, :name => id)

    render :json =>  t.response

  end

end