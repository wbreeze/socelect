require 'test_helper'

class Choice::EditTest < ActionDispatch::IntegrationTest
  include DateTimeDisplayHelper

  setup do
    @choice = create_full_choice
    @choice.save!
    get edit_choice_path(id: @choice.edit_token)
  end

  test 'displays existing opening time for edit' do
    assert_select(
      "span[data-time-field='choice_opening_time']" +
      "[data-time-value='#{time_str(@choice.opening)}']"
    )
  end

  test 'displays existing deadline time for edit' do
    assert_select(
      "span[data-time-field='choice_deadline_time']" +
      "[data-time-value='#{time_str(@choice.deadline)}']"
    )
  end

  test 'does not show choice id' do
    refute_match(/#{choices_path(@choice)}/, @response.body)
  end

  test 'saves altered opening' do
    new_opening = Time.now.utc - 1.day
    params = choice_params_with_alternatives_attributes({
      opening_date: date_str(new_opening),
      opening_time: time_str(new_opening)
    })
    patch choice_path(id: @choice.edit_token), params: { choice: params }
    assert_response :redirect
    @choice.reload
    assert_equal(datetime_formatted(new_opening),
      datetime_formatted(@choice.opening))
  end

  test 'saves altered deadline' do
    new_deadline = Time.now.utc + 2.days
    params = choice_params_with_alternatives_attributes({
      deadline_date: date_str(new_deadline),
      deadline_time: time_str(new_deadline)
    })
    patch choice_path(id: @choice.edit_token), params: { choice: params }
    assert_response :redirect
    @choice.reload
    assert_equal(datetime_formatted(new_deadline),
      datetime_formatted(@choice.deadline))
  end
end
