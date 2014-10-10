class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token


  # GET /receive/1
  def show
     @message_logs = MessageReceive.all  # .where(campaign_id: params[:id])
  end

  # POST /receive
  def create
    message_sid = params[:MessageSid]
    message_date = DateTime.now
    from_phone_number = params[:From]
    to_phone_number = params[:To]
    body = params[:Body]
    status = params[:SmsStatus]

    save_received_message_log(message_sid, message_date, from_phone_number, to_phone_number, body, status)

    # TODO: reply if body contains defined variable to reply.
    
  end

  def save_received_message_log(message_sid, message_date, from_phone, to_phone, body, status)
     @sent_message_log = MessageReceive.new(
                                          sid: message_sid,
                                          date: message_date,
                                          from_phone: from_phone,
                                          to_phone: to_phone,
                                          body: body,
                                          status: status
                                        )
     @sent_message_log.save
   end
end
