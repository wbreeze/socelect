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
  end

  # GET /choices/1/edit
  def edit
    # TODO determine choice eligibility for edit
    @choice = Choice.find(params[:id])
  end

  # POST /choices
  def create
    @choice = Choice.new(choice_params)
    if @choice.save
      render :wrap
    else
      render :new
    end
  end

  # PUT /choices/1
  def update
    params[:choice][:existing_alternative_attributes] ||= {}
    @choice = Choice.find(params[:id])
    if (params.include? 'cancel')
      @choice.delete
      redirect_to :controller => 'welcome', :action => 'index'
    else
      if @choice.update_attributes(choice_params)
        render :wrap
      else
        render :edit
      end
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

  # GET /choices/:id/result
  def result
    @choice = Choice.find(params[:id])
    @alternatives = @choice.alternatives.sort {
      |x,y| -1 * (x.expressions.count <=> y.expressions.count)
    }
  end

  # GET /choices/:id/wrap
  def wrap
    @choice = Choice.find(params[:id])
  end

  def choice_params
    params.require(:choice).permit(
      :title, :description, alternatives_attributes: [
        :title, :description
      ]
    )
  end
end
