class BidsController < ApplicationController

  include SessionsHelper
  include UsersHelper

  before_filter :can_make_bids?, :only => [ :new, :create, :edit, :destroy, :update ]
  before_filter :can_accept_bids?, :only => [ :accept ]

  # GET /bids
  # GET /bids.xml
  def index
    @bids = Bid.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bids }
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show
    @bid = Bid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bid }
    end
  end

  # GET /bids/new
  # GET /bids/new.xml
  def new
    @bid = Bid.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bid }
    end
  end

  # GET /bids/1/edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
    @bid = Bid.new(
      :client_id => params[:client_id],
      :user_id => current_user.id,
      :quantity => params[:quantity],
      :amount => params[:amount] )

    respond_to do |format|
      if @bid.save
        format.html { redirect_to offers_client_path(params[:client_id]) }
        format.xml  { render :xml => @bid, :status => :created, :location => @bid }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @Bid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bids/1
  # PUT /bids/1.xml
  def update
    @bid = Bid.find(params[:id])

    respond_to do |format|
      if @Bid.update_attributes(params[:bid])
        format.html { redirect_to(@bid, :notice => 'bid was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @Bid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.xml
  def destroy
    @bid = Bid.find(params[:id])
    @Bid.destroy

    respond_to do |format|
      format.html { redirect_to(bids_url) }
      format.xml  { head :ok }
    end
  end

  def accept
    # For some reason the params have the offer's id as :client_id
    # and the client's id as :id. Ghhhhrrrrr.

    # We have to change the payee to the one who just
    # accepted the offer.
    b = Bid.find(params[:client_id])
    b.closed = true
    b.save
    redirect_to client_offers_path(params[:id])
  end

  def all
    @offers = Offer.all
    render 'index'
  end

end
