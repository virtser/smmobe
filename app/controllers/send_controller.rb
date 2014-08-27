class SendController < ApplicationController
  def create
    @campaign_id = params[:id]

    # TODO: send all the SMMs to worker for processing.

  end

  def show
  end
end
