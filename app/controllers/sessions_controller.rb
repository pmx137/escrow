#encoding: utf-8
class SessionsController < ApplicationController
  layout :choose_layout

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      if params[:user][:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      if session[:page]
        destination = session[:page]
      else
        destination = pro_index_path
      end
      redirect_to destination, :notice => t(:logged_in_n, :name=> user.firstname)
    else
      @user = User.new(params[:user])
      flash.now.alert = t(:login_failed, :email=> params[:user][:email])
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    session.delete(:user)
    redirect_to root_url, :notice => t(:logout_n)
  end
end