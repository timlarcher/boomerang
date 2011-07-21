class UsersController < ApplicationController

  include SessionsHelper
  include ApplicationHelper

  before_filter :authenticate, :only => [ :show, :index, :edit, :update ]
  before_filter :admin_user, :only => [ :destroy ]
  before_filter :correct_user, :only => [ :edit, :update ]

  def new
    @user = User.new
    @title = "sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash.now[:success] = "Welcome."
      sign_in @user
      redirect_to @user
    else
      @title = 'sign up'
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def index
    @users = User.paginate( :page => params[:page] )
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @title = "edit user"
  end

  def update
    @user = User.find(params[:id])
    @user.first_name = assign_if( params[:user][:first_name] )
    @user.last_name = assign_if( params[:user][:last_name] )
    @user.handle = assign_if( params[:user][:handle] )
    @user.email = assign_if( params[:user][:email] )
    @user.admin = params[:user][:admin] == "1"
    @user.password ||= params[:user][:password] if params[:user][:password].length > 5
    if @user.save
      flash[:success] = "user was successfully updated."
      @users = User.paginate( :page => params[:page] )
      render 'index'
    else
      @title = "edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user destroyed."
    redirect_to users_path
  end

private

  def correct_user
    redirect_to root_path unless current_user.id == params[:id].to_i or admin_user?
  end

end
