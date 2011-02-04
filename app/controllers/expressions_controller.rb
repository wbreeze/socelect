class ExpressionsController < ApplicationController

  # TODO replace this with key based lookup
  def show
    @expression = Expression.find(params[:id])
  end

  # POST /expressions
  def create
    @expression = Expression.new(params[:expression])

      if @expression.save
        redirect_to :action=> :show, :id => @expression.id 
      else
        redirect_to :controller => 'choice', :action => 'show',
          :id => @expression.preference.choice
      end
  end
end
