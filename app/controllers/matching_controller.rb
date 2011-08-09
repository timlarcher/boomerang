class MatchingController < ApplicationController

  include SessionsHelper
  include Matcher

  before_filter :authenticate

  def new
    @matching = Matching.new
  end

  def create
    @matching = Matching.new( params[:matching] )
    @matching.amount_paid = 0.0
    if @matching.save
      flash.now[:success] = "#{@matching.id} added."
      redirect_to @matching
    else
      @title = 'add new matching'
      render 'new'
    end
  end

  def index
    if admin_user?
      @matching = Matching.all.paginate( :page => params[:page] )
      @audits = Audit.all.paginate( :page => params[:page] )
    else
      @matching = Matching.where( "payee_client_id = ? or payer_client_id = ?", current_user.client_id, current_user.client_id ).paginate( :page => params[:page] )
      @audits = []
    end
  end

  def show
    @matching = Matching.find(params[:id])
  end

  def edit
    @matching = Matching.find(params[:id])
    @title = "edit matching"
  end

  def update
    @matching = Matching.find(params[:id])
    if @matching.update_attributes(params[:matching])
      flash[:success] = "#{@matching.id} was successfully updated."
      redirect_to @matching
    else
      @title = "edit matching"
      render 'edit'
    end
  end

  def destroy
    Matching.find(params[:id]).destroy
    flash[:success] = "matching deleted."
    redirect_to matching_path
  end

  def delete_all
    Matching.all.each { |m| m.destroy }
    redirect_to root_path
  end

  def do_match
    @before_matching = Matching.all.paginate( :page => params[:page] )
    Client.find(:all).each do |client|
      Matcher::do_match( client.id )
    end
    self.index
    render 'index'
  end

end
