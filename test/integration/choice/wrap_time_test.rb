require 'test_helper'

class WrapTimeTest < ActionDispatch::IntegrationTest
  include DateTimeDisplayHelper

  setup do
    @choice = create_full_choice
    @choice.save!
  end

  test 'wrap shows opening date and time' do
    freeze_time do
      get wrap_choice_path(@choice.edit_token)
      assert_response :success
      assert_match(datetime_full_display(@choice.opening), @response.body)
    end
  end

  test 'wrap shows deadline date and time' do
    freeze_time do
      get wrap_choice_path(@choice.edit_token)
      assert_response :success
      assert_match(datetime_full_display(@choice.deadline), @response.body)
    end
  end
end
