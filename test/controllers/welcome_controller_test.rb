require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "renders index" do
    get :index
    assert_response :success
  end
end
