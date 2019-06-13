class WelcomeController < ApplicationController

def index
    #p request.env['REMOTE_HOST']
    #p request.env['REMOTE_ADDR']
end

def page_view
  render(params[:page])
end

end
