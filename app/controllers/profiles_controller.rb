#encoding: utf-8
class ProfilesController < ApplicationController

  layout :choose_layout
  before_filter :user_required

  def index
    user = current_user
    add_breadcrumb('Lista zaliczek', pro_index_path)
    @outgoing_payments = user.outgoing_payments
    @incoming_payments = user.incoming_payments
  end

  def details
    @payment = Payment.find_by_id(params[:id])
    error = "Nie ma takiej Płatności"
    if @payment.blank?
      redirect_to pro_index_path, :error=> error
    else
      check_permitions(@payment.payer_id, @payment.recipient_id, error)
    end
  end

  def edit
    @user = User.find_by_id current_user.id
    render :layout=> 'iframe'
  end

  def save
    @user = User.find_by_id current_user.id
    if @user.update_attributes(params[:user])
      redirect_to pro_edit_path, :notice=> 'Dane zostały zmienione'
    else
      render :action=> 'edit', :layout=> 'iframe'
    end
  end

  def pass
    @user = User.find_by_id current_user.id
    render :layout=> 'iframe'
  end
  
  def change_pass
    @user = User.find_by_id current_user.id
    if @user.update_attributes(params[:user])
      redirect_to pro_pass_path, :notice=> 'Hasło zostało zmienione'
    else
      render :action=> 'pass', :layout=> 'iframe'
    end
  end

  def pay_me
    add_breadcrumb('Lista zaliczek', pro_index_path)
    add_breadcrumb('Wykonaj przelew', request.fullpath)
    get_payment_details params[:url_token]
  end

  def pay_recipient
    payment = Payment.payer_and_url_token(current_user.id, params[:url_token]).first
    payment.payment_state = 1
    payment.end_date = Time.now
    payment.payment_date = Time.now
    payment.save(:validate=> false)
    UserMailer.pay_to_recipient(payment).deliver
    render :text=> 'ok'
  end

  def ask_for_payment
    payment = Payment.recipient_and_url_token(current_user.id, params[:url_token]).first
    payment.is_asked = true
    payment.payment_date = Time.now
    payment.end_date = Time.now+7.days
    payment.save(:validate=> false)
    UserMailer.ask_for_payment(payment).deliver
    render :text=> 'ok'
  end

  def delete
    payment = Payment.payer_and_url_token(current_user.id, params[:url_token]).first
    payment.update_attribute('is_deleted', true)
    render :text=> true
  end

  def edit_account
    @payment = Payment.recipient_and_url_token(current_user.id, params[:url_token]).first
    render :layout=> 'iframe'
  end

  def save_account
    @payment = Payment.recipient_and_url_token(current_user.id, params[:url_token]).first
    @payment.attributes = params[:payment]
    if @payment.save
      redirect_to pro_edit_account_path(params[:url_token]), :notice=> 'Rachunek został poprawnie zmieniony'
    else
      flash.now.alert = "Wystąpił błąd"
      render :action=> 'edit_account', :layout=> 'iframe'
    end
  end
end