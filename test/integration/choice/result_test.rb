require 'test_helper'

class Choice::ResultTest < ActionDispatch::IntegrationTest
  include DateTimeDisplayHelper

  setup do
    @choice = create_full_choice
  end

  def get_results_page
    @choice.save!
    get result_choice_path(id: @choice.read_token)
    assert_response :success
  end

  test 'displays intermediate result when enabled' do
    @choice.update_attributes(intermediate: true)
    get_results_page
    assert_select('div[data-parto-items]')
  end

  test 'displays future closing time when intermediate enabled' do
    freeze_time do
      @choice.update_attributes(intermediate: true)
      get_results_page
      assert_select('p', /Intermediate results. This choice will close/)
      assert_match(datetime_full_display(@choice.deadline), @response.body)
    end
  end

  test 'displays closed when closing time has passed' do
    travel_to(@choice.deadline) do
      get_results_page
      assert_select('p', /This choice closed to further responses/)
      assert_match(datetime_full_display(@choice.deadline), @response.body)
    end
  end

  test 'displays closing time when intermediate result disabled' do
    freeze_time do
      get_results_page
      assert_select('p', /Results of this choice will become available/)
      assert_match(datetime_full_display(@choice.deadline), @response.body)
    end
  end

  test 'displays pending computation when computing state' do
    @choice.save! # hit before_create callback
    @choice.result_state = "computing"
    get_results_page
    assert_select('p', /Computation in progress/)
  end
end
