#encoding: utf-8
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(params[:user])
    if user.save
      redirect_to login_path, :notice => t(:user_create_n)
    else
      @user = user
      render "new"
    end
  end
end