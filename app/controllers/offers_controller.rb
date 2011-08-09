class OffersController < ApplicationController

  include SessionsHelper
  include UsersHelper

  before_filter :can_make_offers?, :only => [ :new, :create, :edit, :destroy, :update ]
  before_filter :can_accept_offers?, :only => [ :accept ]

  # GET /offers
  # GET /offers.xml
  def index
    @offers = Offer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @offers }
    end
  end

  # GET /offers/1
  # GET /offers/1.xml
  def show
    @offer = Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @offer }
    end
  end

  # GET /offers/new
  # GET /offers/new.xml
  def new
    @offer = Offer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @offer }
    end
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.find(params[:id])
  end

  # POST /offers
  # POST /offers.xml
  def create
    @offer = Offer.new(
      :client_id => params[:client_id],
      :user_id => current_user.id,
      :quantity => params[:quantity],
      :amount => params[:amount] )

    respond_to do |format|
      if @offer.save
        format.html { redirect_to offers_client_path(params[:client_id]) }
        format.xml  { render :xml => @offer, :status => :created, :location => @offer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /offers/1
  # PUT /offers/1.xml
  def update
    @offer = Offer.find(params[:id])

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        format.html { redirect_to(@offer, :notice => 'Offer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.xml
  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy

    respond_to do |format|
      format.html { redirect_to(offers_url) }
      format.xml  { head :ok }
    end
  end

  def accept
    # For some reason the params have the offer's id as :client_id
    # and the client's id as :id. Ghhhhrrrrr.

    # We have to change the payee to the one who just
    # accepted the offer.
    o = Offer.find(params[:client_id])
    o.closed = true
    o.save
    redirect_to client_path(params[:id])
  end

  def all
    @offers = Offer.all
    render 'index'
  end

end
