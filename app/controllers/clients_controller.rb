class ClientsController < ApplicationController

  include SessionsHelper

  before_filter :authenticate

  def new
    @client = Client.new
    @title = "add new client"
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash.now[:success] = "#{@client.name} added."
      redirect_to @client
    else
      @title = 'add new client'
      render 'new'
    end
  end

  def index
    @title = "list clients"
    @clients = Client.all.paginate( :page => params[:page] )
  end

  def show
    @client = Client.find(params[:id])
  end

  def edit
    @client = Client.find(params[:id])
    @title = "edit client"
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:success] = "#{@client.name} was successfully updated."
      redirect_to @client
    else
      @title = "edit client"
      render 'edit'
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = "client deleted."
    @clients = Client.all.paginate( :page => params[:page] )
    render 'index'
    #redirect_to client_path
  end

  def offers
    m = Matching.payers(params[:id])
    if m
      @payables = 0.0
      m.each do |me|
        @payables += me.amount_unpaid
      end
    else
      flash[:error] = "There are no payables for that client."
      redirect_to( clients_path ) and return
    end
    @client = Client.find(params[:id])
    @bids = Bid.for_client(params[:id]).active.paginate( :page => params[:page] )
    @offers = Offer.for_client(params[:id]).active.paginate( :page => params[:page] )
    render 'clients/offers'
  end

  def match
    @before_matching = Matching.all
    logger.debug "params id = #{params[:id]} "
    Matcher::do_match( params[:id] )
    @amount = 0.0
    @amount_paid = 0.0
    @audit_amount = 0.0
    @title = "list matching"
    @matching = Matching.all
    @audits = Audit.all
    render 'matching/index'
  end

end
