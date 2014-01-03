#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  add_breadcrumb 'Strona główna', :home_path

  helper :all

  def current_user
    if cookies[:auth_token]
     @current_user ||= User.find_by_auth_token!(cookies[:auth_token])
    else
      false
    end
  end
  helper_method :current_user

  def choose_layout
    (request.xhr?) ? nil : 'application'
  end

  def redirect_to_home(flash=false)
    redirect_to home_path, :error=> flash || t('page_not_found')
  end

  def user_required
    unless current_user
      session[:page] = request.fullpath
      redirect_to login_path, :alert=> t(:user_required)
    end
  end

  def check_permitions(user_1, user_2, flash=false)
    if user_1 != current_user.id and user_2 != current_user.id
      redirect_to pro_index_path, :flash=> {:error=> flash||="Brak sporu"}
    end
  end

  def get_payment_details(url_token)
    @payment = Payment.by_url_token(url_token).first
    if @payment.blank?
      redirect_to_home
    end
  end
end