#encoding: utf-8
class UserMailer < ActionMailer::Base
  layout 'mailer'
  default :from => 'MojaZaliczka.pl <info@mojazaliczka.pl>'
  helper :application

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Zmiana hasło w serwisie MojaZaliczka.pl"
  end

  def new_payer(user)
    @user = user
    mail :to => @user.email, :subject => "Nowe konto na MojaZaliczka.pl"
  end

  def new_recipient(user)
    @user = user
    mail :to => @user.email, :subject => "Nowe konto na MojaZaliczka.pl"
  end

  def payment_for_payer(user, payment)
    @user = user
    @payment = payment
    mail :to => @user.email, :subject => "Szczegóły zaliczki"
  end

  def payment_for_recipient(user, payment)
    @user = user
    @payment = payment
    mail :to => user.email, :subject => "Pojawiła się nowa zaliczka"
  end

  def new_dispute(dispute)
    @dispute = dispute
    mail :to => dispute.defendant.email, :subject => "Nowy spór o zaliczkę"
  end

  def edit_dispute(dispute)
    @dispute = dispute
    mail :to => dispute.defendant.email, :subject => "Zmiany w sporze o zaliczkę"
  end

  def new_dispute_comment comment
    @dispute = comment.dispute
    @comment = comment
    @recipient = comment.user_id == @dispute.defendant.id ? @dispute.complainant : @dispute.defendant
    mail :to => @recipient.email, :subject => "Nowy komentarz w sporze"
  end

  def ask_for_payment payment
    @payment = payment
    mail :to => @payment.payer_email, :subject => "Wykonawca prosi o wypłatę"
  end

  def pay_to_recipient payment
    @payment = payment
    mail :to => @payment.recipient_email, :subject => "Płatność za wykonanie zlecenia"
  end
end