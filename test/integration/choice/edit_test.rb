require 'test_helper'

class Choice::ResultTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice
    @choice.save!
    get edit_choice_path(id: @choice.edit_token)
  end

  test 'displays existing opening time for edit' do
    assert_select(
      "span[data-time-field='choice_opening_time']" +
      "[data-time-value='#{@choice.opening_time}']"
    )
  end

  test 'displays existing deadline time for edit' do
    assert_select(
      "span[data-time-field='choice_deadline_time']" +
      "[data-time-value='#{@choice.deadline_time}']"
    )
  end
end
