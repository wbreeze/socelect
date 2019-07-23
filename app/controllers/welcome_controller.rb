class WelcomeController < ApplicationController
  CHOICE_LIMIT = 12

  def index
    @choices = Choice.where(public: true).order(:deadline).limit(CHOICE_LIMIT)
  end

  def page_view
    page_list = %w(terms contact)
    page_index = page_list.find_index(params[:page])
    page_wanted = page_index ? page_list[page_index] : 'index'
    render(page_wanted)
  end
end
