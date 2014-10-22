class StaticPagesController < ApplicationController
  before_action :clear_message

  def home
  end

  def help
  end

  def contact
  end

  def about
  end

  private
    # Clear sms message on phone screen left from previous campaign setup
    def clear_message
      flash[:message_text] = nil
    end
end
