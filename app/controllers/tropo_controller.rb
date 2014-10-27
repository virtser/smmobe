class TropoController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+12898140357'


  # POST /tropo.json
  def index

    t = Tropo::Generator.new()
    t.call(:from => PROD_PHONE_NUMBER, :to => '+972544472571', :network => "SMS", :name => '999')
    t.say(:value => 'test', :name => '999')

    render :json =>  t.response

  end

end