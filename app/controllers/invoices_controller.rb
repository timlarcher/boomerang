class InvoicesController < ApplicationController

  include SessionsHelper

  before_filter :authenticate

  def new
    @invoices = Invoice.new
    @title = "add new invoices"
  end

  def create
    @invoices = Invoice.new(params[:invoices])
    if @invoices.save
      flash.now[:success] = "#{@invoices.id} added."
      redirect_to @invoices
    else
      @title = 'add new invoices'
      render 'new'
    end
  end

  def index
    if admin_user?
      @invoices = Invoice.all.paginate( :page => params[:page] )
    else
      @invoices = Invoice.where( "payee_client_id = ? or payer_client_id = ?", current_user.client_id, current_user.client_id ).paginate( :page => params[:page] )
    end
  end

  def files
    @files = []
    if admin_user?
      client_id = params[:for_client_id] || 1
    else
      client_id = current_user.client_id
    end
    @dirname = Invoice.in_dir( client_id )
    begin
      Dir.foreach(@dirname) do |f|
        @files << f if f =~ /.csv$/
      end
    rescue Exception
    end
  end

  def load
    Invoice.load_data( params[:dir], params[:name] )
    f = params[:dir] + params[:name]
    File.rename( f, f + ".proc" )
    redirect_to invoices_path
  end

  def show
    @invoices = Invoice.find(params[:id])
  end

  def edit
    @invoices = Invoice.find(params[:id])
    @title = "edit invoices"
  end

  def update
    @invoices = Invoice.find(params[:id])
    if @invoices.update_attributes(params[:invoices])
      flash[:success] = "#{@invoices.id} was successfully updated."
      redirect_to @invoices
    else
      @title = "edit invoices"
      render 'edit'
    end
  end

  def destroy
    Invoice.find(params[:id]).destroy
    flash[:success] = "invoices deleted."
    redirect_to invoices_path
  end

  def delete_all
    Invoice.all.each do |i|
      i.delete
    end
    redirect_to invoices_path
  end

  def delete_file
    begin
      File.delete( params[:dir] + params[:name])
    rescue Exception
    end
    redirect_to invoices_path
  end

  def view_file
    @file_lines = []
    @filename = params[:name]
    @dirname = params[:dir]
    begin
      File.open( @dirname + @filename ).each_line do |l|
        @file_lines << l
      end
    rescue Exception
    end
    render 'view_file'
  end

end
