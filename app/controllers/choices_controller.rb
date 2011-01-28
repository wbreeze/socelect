class ChoicesController < ApplicationController
  # GET /choices
  # GET /choices.xml
  def index
    @choices = Choice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @choices }
    end
  end

  # GET /choices/1
  # GET /choices/1.xml
  def show
    @choice = Choice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @choice }
    end
  end

  # GET /choices/new
  # GET /choices/new.xml
  def new
    @choice = Choice.new
    @choice.alternatives.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @choice }
    end
  end

  # GET /choices/1/edit
  def edit
    @choice = Choice.find(params[:id])
  end

    def set_missing_title_from_description(pchoice)
      pchoice[:title].strip!
      if pchoice[:title].empty?
        md = pchoice[:description].match('[^.;!?]+\?') || 
             pchoice[:description].match('^[^.;!]+[.;!]');
        pchoice[:title] = md ? md.to_s.strip : pchoice[:description].slice(0,40)
      end
    end

  # POST /choices
  # POST /choices.xml
  def create
    set_missing_title_from_description(params[:choice])
    @choice = Choice.new(params[:choice])

    respond_to do |format|
      if @choice.save
        format.html { 
          redirect_to(@choice, :action => :edit, :notice => 'Choice was successfully created.')
        }
        format.xml  { render :xml => @choice, :status => :created, :location => @choice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @choice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /choices/1
  # PUT /choices/1.xml
  def update
    params[:choice][:existing_alternative_attributes] ||= {}
    set_missing_title_from_description(params[:choice])
    @choice = Choice.find(params[:id])

    respond_to do |format|
      if @choice.update_attributes(params[:choice])
        format.html { redirect_to(@choice, :notice => 'Choice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @choice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /choices/1
  # DELETE /choices/1.xml
  def destroy
    @choice = Choice.find(params[:id])
    @choice.destroy

    respond_to do |format|
      format.html { redirect_to(choices_url) }
      format.xml  { head :ok }
    end
  end
end
