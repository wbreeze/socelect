require 'test_helper'

class SelectionTest < ActionDispatch::IntegrationTest
  include DateTimeDisplayHelper

  setup do
    @choice = create_full_choice
  end

  def get_selection
    @choice.save!
    get choice_path(@choice.read_token)
    assert_response :success
  end

  test 'has choice identified' do
    get_selection
    assert_select("input[name='choice[read_token]']") do
      assert_select("input[value='#{@choice.read_token}']");
    end
  end

  test 'has stem' do
    get_selection
    assert_select('div[class="choiceTitle"]', @choice.title)
  end

  test 'displays future closing date and time' do
    get_selection
    assert_select('p', /Express your preference before/)
    assert_match(datetime_full_display(@choice.deadline), @response.body)
  end

  test 'displays closing date if choice deadline is now' do
    travel_to(@choice.deadline) do
      get_selection
      assert_select('p', /This choice closed for selection/)
      assert_match(datetime_full_display(@choice.deadline), @response.body)
    end
  end

  test 'displays closing date if choice deadline has passed' do
    travel_to(@choice.deadline + 1.minute) do
      get_selection
      assert_select('p', /This choice closed for selection/)
      assert_match(datetime_full_display(@choice.deadline), @response.body)
    end
  end

  test 'displays opening date if choice has not yet opened' do
    travel_to(@choice.opening - 1.minute) do
      get_selection
      assert_select('p', /This choice will open for selection/)
      assert_match(datetime_full_display(@choice.opening), @response.body)
    end
  end
end
