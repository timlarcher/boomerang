class DemosController < ApplicationController

  # GET /demos
  # GET /demos.xml
  def index
    @demos = Demo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @demos }
    end
  end

  # GET /demos/1
  # GET /demos/1.xml
  def show
    @demo = Demo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @demo }
    end
  end

  # GET /demos/new
  # GET /demos/new.xml
  def new
    @demo = Demo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @demo }
    end
  end

  # GET /demos/1/edit
  def edit
    @demo = Demo.find(params[:id])
  end

  # POST /demos
  # POST /demos.xml
  def create
    @demo = Demo.new(params[:demo])

    respond_to do |format|
      if @demo.save
        format.html { redirect_to(@demo, :notice => 'Demo was successfully created.') }
        format.xml  { render :xml => @demo, :status => :created, :location => @demo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @demo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /demos/1
  # PUT /demos/1.xml
  def update
    @demo = Demo.find(params[:id])

    respond_to do |format|
      if @demo.update_attributes(params[:demo])
        format.html { redirect_to(@demo, :notice => 'Demo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @demo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /demos/1
  # DELETE /demos/1.xml
  def destroy
    @demo = Demo.find(params[:id])
    @demo.destroy

    respond_to do |format|
      format.html { redirect_to(demos_url) }
      format.xml  { head :ok }
    end
  end

  def load
    Matching.load_data( Demo.find(params[:id]).filename )
    redirect_to matching_index_path
  end

end
