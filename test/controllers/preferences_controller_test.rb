require 'test_helper'

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice
    @choice.save!
  end

  test 'should post selection by read token' do
    params = selection_params(@choice)
    post preferences_path, params: params
    assert_response :redirect
  end
end