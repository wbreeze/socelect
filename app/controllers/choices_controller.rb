require 'choice/parto_coding'

class ChoicesController < ApplicationController

  # GET /choices/1
  def show
    @choice = Choice.find_by(read_token: params[:id])
    head :not_found unless @choice
    @choice.extend(Choice::PartoCoding)
  end

  # GET /choices/new
  def new
    @choice = Choice::EnsureAlternatives.new
  end

  # GET /choices/1/edit
  def edit
    @choice = Choice::Edit.find_by(edit_token: params[:id])
    head :not_found unless @choice
  end

  # POST /choices
  def create
    @choice = Choice::Edit.new(choice_params)
    if @choice.save
      redirect_to wrap_choice_path(@choice.edit_token)
    else
      render :new
    end
  end

  # PUT /choices/1
  def update
    @choice = Choice::Edit.find_by(edit_token: params[:id])
    unless @choice
      return head :bad_request
    end
    if @choice.update(choice_params)
      redirect_to wrap_choice_path(@choice.edit_token)
    else
      render :edit, id: @choice.edit_token
    end
  end

  # GET /choices/:id/result
  def result
    @choice = Choice.find_by(read_token: params[:id])
    return head :not_found unless @choice
    @choice.extend(Choice::PartoCoding)
    @parto = @choice.result_parto
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
      :intermediate, :public,
      alternatives_attributes: [ :id, :title, :description, :_destroy ]
    )
  end
end
