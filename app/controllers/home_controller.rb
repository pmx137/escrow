#encoding: utf-8
class HomeController < ApplicationController
  layout :choose_layout

  def index
  end

  def mission
    add_breadcrumb('Misja', mission_path)
  end

  def contact
    add_breadcrumb('Kontakt z nami', contact_path)
    @message = Message.new
    @current_page = contact_path
  end

  def create_contact
    @message = Message.new(params[:message])
    if @message.valid?
      OrderMailer.send_contact(@message, request.remote_ip).deliver
      if request.xhr?
        render :template => 'home/create_contact.js.erb'
      else
        redirect_to contact_path, :notice=> t('message_sent')
      end
    else
      render :action => 'home/contact'
    end
  end

  def regulations

  end

end
