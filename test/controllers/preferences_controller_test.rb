require 'test_helper'

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @choice = create_full_choice
    @choice.save!
  end

  test 'posts selection' do
    params = selection_params(@choice)
    post preferences_path, params: params
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test 'posts partial ordering' do
    params = parto_selection_params(@choice)
    post preferences_path, params: params
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test 'creates new_pref event job on post' do
    assert_enqueued_with(
      job: ResultState::NewPrefJob, queue: 'result_state'
    ) do
      params = parto_selection_params(@choice)
      post preferences_path, params: params
      assert_response :redirect
    end
  end
end
