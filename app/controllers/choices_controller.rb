class ChoicesController < ApplicationController

  # GET /choices/1
  def show
    @choice = Choice.find_by(read_token: params[:id])
    head :not_found unless @choice
  end

  # GET /choices/new
  def new
    @choice = Choice.new
    @choice.ensure_two_alternatives
  end

  # GET /choices/1/edit
  def edit
    @choice = Choice.find_by(edit_token: params[:id])
    head :not_found unless @choice
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
    @choice = Choice.find_by(edit_token: params[:id])
    return head :bad_request unless @choice
    if @choice.update_attributes(choice_params)
      render :wrap
    else
      render :edit
    end
  end

  # POST /choices/:id/selection
  def selection
    @choice = Choice.find_by(read_token: params[:id])
    return head :bad_request unless @choice
    @alternative = @choice.alternatives.find(params[:alternative])
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
    @preference = Preference.find(params[:id])
    @choice = @preference.choice
    @alternative = @preference.expression[0].alternative
  end

  # GET /choices/:id/result
  def result
    @choice = Choice.find_by(read_token: params[:id])
    return head :not_found unless @choice
    @alternatives = @choice.alternatives.sort {
      |x,y| -1 * (x.expressions.count <=> y.expressions.count)
    }
  end

  # GET /choices/:id/wrap
  def wrap
    @choice = Choice.find_by(edit_token: params[:id])
    head :not_found unless @choice
  end

  def choice_params
    params.require(:choice).permit(
      :title, :description,
      :opening_date, :opening_time,
      :deadline_date, :deadline_time,
      alternatives_attributes: [ :id, :title, :description, :_destroy ]
    )
  end
end
