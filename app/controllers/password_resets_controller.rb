#encoding: utf-8
class PasswordResetsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:user][:email])
    user.send_password_reset if user
    redirect_to login_path, :notice => t(:sent_password, :email=> params[:user][:email])
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => t(:invalid_link_reset)
    elsif @user.update_attributes(params[:user])
      redirect_to login_path, :notice => t(:password_success)
    else
      render :edit
    end
  end
end