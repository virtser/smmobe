class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /send
  def index
    message_sid = params[:SID]
    message_date = params[:Date]
    from_phone = params[:From]
    to_phone = params[:To]
    body - params[:Body]
    status - params[:Status]

    save_message(message_sid, message_date, from_phone_number, to_phone_number, body, status)
  end

  def save_message(message_sid, message_date, from_phone, to_phone, body, status)

  end

end
