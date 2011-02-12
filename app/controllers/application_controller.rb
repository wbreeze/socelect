class ApplicationController < ActionController::Base
  protect_from_forgery

  # return the authenticated user's Person record
  # return the anonymous Person record if the user has not authenticated
  def get_current_person
    #TODO authenticated user from session
    #TODO use configuration for anonymous user
    anon = 'anonymous@socelect.com'
  end
end
