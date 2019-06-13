class WelcomeController < ApplicationController
  def index
  end

  def page_view
    page_list = %w(terms contact)
    page_index = page_list.find_index(params[:page])
    page_wanted = page_index ? page_list[page_index] : 'index'
    render(page_wanted)
  end
end
