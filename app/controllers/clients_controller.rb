class ClientsController < ApplicationController

  #include SessionsHelper

  #before_filter :authenticate, :except => [ :show, :index ]
  #before_filter :admin_player, :except => [ :show, :index ]

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

end
