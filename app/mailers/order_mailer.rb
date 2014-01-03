#encoding: utf-8
class OrderMailer < ActionMailer::Base
  layout 'mailer'
  default :from => 'MojaZaliczka.pl <info@mojazaliczka.pl>'
  helper :application

  def send_contact(message, ip)
    @message = message
    @ip = ip
    mail(:to => 'rafath@zaraz.pl', :subject => "Kontakt z MojaZaliczka.pl")
  end
end