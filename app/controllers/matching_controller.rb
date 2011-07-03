class MatchingController < ApplicationController

  #include SessionsHelper
  include Matcher

  #before_filter :authenticate, :except => [ :show, :index ]
  #before_filter :admin_player, :except => [ :show, :index ]

  def new
    @matching = Matching.new
    @title = "add new matching"
  end

  def create
    @matching = Matching.new(params[:matching])
    if @matching.save
      flash.now[:success] = "#{@matching.id} added."
      redirect_to @matching
    else
      @title = 'add new matching'
      render 'new'
    end
  end

  def index
    @title = "list matching"
    @matching = Matching.all.paginate( :page => params[:page] )
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

  def do_match
    Client.find(:all).each do |client|
      Matcher::do_match( client.id )
    end
    redirect_to matching_index_path
  end

end
