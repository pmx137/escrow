#encoding: utf-8
require 'net/http'
require 'hpricot'
require 'open-uri'
require 'uri'
class PaymentsController < ApplicationController

  def new_payment
    if params[:id] == '1'
      @page_title = 'Poproś o zaliczkę'
    else
      @page_title = 'Wpłać zaliczkę'
    end
    add_breadcrumb(@page_title, request.fullpath)
    @payment = Payment.new
    if current_user
      if params[:id] == '1'
        @payment.r_firstname = current_user.firstname
        @payment.r_lastname = current_user.lastname
        @payment.r_email = current_user.email
        @payment.r_account_owner = current_user.account_owner
        @payment.r_account_no = current_user.account_no
      else
        @payment.p_firstname = current_user.firstname
        @payment.p_lastname = current_user.lastname
        @payment.p_email = current_user.email
        @payment.p_mobile = current_user.mobile
      end
    end
  end

  def create_payment
    unless params[:payment].blank?
      payment = Payment.new(params[:payment])
      payment.ip = request.remote_ip
      payment.amount = params[:payment][:amount].gsub(/,/, '.').to_f
      unless payment.service_url.blank?
        url = payment.title
        payment.title = payment.service_url
        payment.service_url = url
      end
      if payment.save
        UserMailer.payment_for_payer(payment.payer, payment).deliver
        UserMailer.payment_for_recipient(payment.recipient, payment).deliver
        redirect_to payment_details_path(payment.url_token), :notice=> 'Szczegóły zaliczki zostały zapisane'
      else
        if params[:id] == '1'
          @page_title = 'Poproś o zaliczkę'
        else
          @page_title = 'Wpłać zaliczkę'
        end
        @payment = payment
        render :action=> 'new_payment'
      end
    end
  end

  def payment_details
    add_breadcrumb('Szczegóły zaliczki', request.fullpath)
    get_payment_details params[:url_token]
  end

  def get_title
    unless params[:url].blank?
      begin
        url = CGI.unescape(params[:url])
        url = "http://#{url}" unless url.include? 'http'
        doc = open(url) { |f| Hpricot(f) }
        title = (doc/'html/head/title').first.inner_html
        charset = (doc/'meta[@content*=charset]').first.to_html
        matched = charset.match(/(iso|utf)+[0-9-]+/i)
        if !title.blank? and !matched.blank? and matched[0].include? '8859-2'
          title = Iconv.iconv('utf-8', 'iso-8859-2', title).to_s
        end
        render :text=> title.strip
      rescue
        render :text=> 'Wpisz tytuł'
      end
    else
      render :text=> ''
    end
  end
end