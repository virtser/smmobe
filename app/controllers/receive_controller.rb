class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token


  # GET /receive/1
  def show
     @message_logs = MessageReceive.all  # .where(campaign_id: params[:id])
  end

  # GET /receive
  def index
    if(params[:messageId].present?)
      message_sid = params[:messageId]
      from_phone_number = params[:msisdn]
      to_phone_number = params[:to]
      body = params[:text]
      status = params[:type]

      save_received_message_log(message_sid, from_phone_number, to_phone_number, body, status)

      # TODO: reply if body contains defined variable to reply.
    end
    render :nothing => true # this will supply the needed http 200 OK
  end

  def save_received_message_log(message_sid, from_phone, to_phone, body, status)
     @sent_message_log = MessageReceive.new(
        sid: message_sid,
        date: DateTime.now,
        from_phone: from_phone,
        to_phone: to_phone,
        body: body,
        status: status
     )
     @sent_message_log.save
   end
end
