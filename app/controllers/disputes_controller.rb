#encoding: utf-8
class DisputesController < ApplicationController

  before_filter :user_required
  before_filter :add_2_bc

  def index
    @payment = Payment.find_by_id(params[:id])
    if @payment.dispute.blank?
      redirect_to dis_add_dispute_path(params[:id])
    else
      check_permitions(@payment.payer_id, @payment.recipient_id)
      add_breadcrumb 'Spór o zaliczkę', dis_index_path(params[:id])
      @dispute_comment = DisputeComment.new
      @dispute_comment.dispute_id = @payment.dispute.id
      @dispute_comment.payment_id = @payment.id
    end
  end

  def add_dispute
    #todo: dodac sprawdzanie czy istnieje juz spor
    @payment = Payment.find_by_id(params[:id])
    if @payment.blank?
      redirect_to pro_index_path, :error=> 'Nie ma takiej zaliczki'
    else
      check_permitions(@payment.payer_id, @payment.recipient_id)

      @dispute = Dispute.new
      @dispute.payment_id = params[:id]
      @dispute.complainant_id = current_user.id
      @dispute.defendant_id = current_user.id == @payment.payer_id ? @payment.recipient_id : @payment.payer_id

      add_breadcrumb 'Dodaj spór', dis_add_dispute_path(params[:id])
    end
  end

  def edit_dispute
    @payment = Payment.find_by_id(params[:id])
    check_permitions(@payment.payer_id, @payment.recipient_id)

    @dispute = @payment.dispute
    @dispute.complaint = ''
    add_breadcrumb 'Edycja sporu', dis_edit_dispute_path(params[:id])
    render :action=> :add_dispute
  end

  def save
    dispute = Dispute.find_by_payment_id(params[:dispute][:payment_id])
    params[:dispute][:amount_to_pay] = params[:dispute][:amount_to_pay].to_f
    if dispute.blank?
      dispute = Dispute.new(params[:dispute])
    else
      dispute.attributes = params[:dispute]
    end
    if dispute.save
      if dispute.new_record?
        UserMailer.new_dispute(dispute).deliver
      else
        UserMailer.edit_dispute(dispute).deliver
      end
      redirect_to dis_index_path(params[:dispute][:payment_id]), :notice=> 'Zmiany zostały zapisane'
    else
      @dispute = dispute
      render :action=> 'add_dispute'
    end
  end

  def add_comment
    dc = DisputeComment.new(params[:dispute_comment])
    dc.user_id = current_user.id
    dc.ip = request.remote_ip
    if dc.save
      UserMailer.new_dispute_comment(dc).deliver
      redirect_to dis_index_path(dc.payment_id), :notice=> 'Komentarz zostały zapisany'
    end
  end

  private

  def add_2_bc
    add_breadcrumb 'Moje konto', pro_index_path
  end
end