class StaticPagesController < ApplicationController
  before_action :clear_message

  def home
    if current_user.nil?
      redirect_to '/signin'
    else
      redirect_to :controller => 'campaigns', :action => 'new'
    end
  end

  def help
  end

  def contact
  end

  def about
  end

  private
    # Clear sms message baloon on phone screen left from previous campaign setup
    def clear_message
      flash[:message_text] = nil
    end
end
