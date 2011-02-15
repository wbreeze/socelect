class ChoicesController < ApplicationController

  # GET /choices/1
  def show
    @choice = Choice.find(params[:id])
    @person = get_current_person
    # TODO determine person eligibility for choice
  end

  # GET /choices/new
  def new
    @choice = Choice.new
    @choice.alternatives.build
  end

  # GET /choices/1/edit
  def edit
    # TODO determine choice eligibility for edit
    @choice = Choice.find(params[:id])
  end

  # GET /choices/1/finish
  def finish
    @choice = Choice.find(params[:id])
  end

  # POST /choices
  def create
    @choice = Choice.new(params[:choice])
    @choice.ensureTwoAlternatives
    if @choice.save
      redirect_to :action=> :edit, :id => @choice.id 
    else
      render :action => "new" 
    end
  end

  # PUT /choices/1
  def update
    params[:choice][:existing_alternative_attributes] ||= {}
    @choice = Choice.find(params[:id])
    if @choice.update_attributes(params[:choice])
      redirect_to :action => :finish, :id => @choice.id
    else
      render :action => "edit" 
    end
  end

  # POST /choices/1/publish
  def publish
    @choice = Choice.find(params[:id])
    if @choice.update_attributes(params[:choice])
      redirect_to :action => :show, :id => @choice.id
    else
      render :action => 'finish'
    end
  end

  # POST /choices/:id/selection
  def selection
    @choice = Choice.find(params[:id])
    @alternative = Alternative.find(params[:alternative])
    @person = get_current_person
    @preference = Preference.new(:choice => @choice)
    @preference.chef_parameters(request)
    @expression = @preference.expression.build(:sequence => 1)
    @expression.alternative = @alternative

    if @preference.save
      redirect_to :action=> :confirm, :id => @preference.id 
    else
      render :action => 'show', :id => @expression.preference.choice
    end
  end

  # GET /choices/:id/confirm
  # :id is Preference id
  def confirm
    #TODO validate requester has access to preference
    @preference = Preference.find(params[:id])
    @choice = @preference.choice
    @alternative = @preference.expression[0].alternative
  end

end
