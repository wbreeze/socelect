require 'test_helper'

class Choice::ResultTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice
    @choice.save
  end

  test 'displays intermediate result when enabled' do
    @choice.update_attributes(intermediate: true)
    get result_choice_path(id: @choice.read_token)
    assert_response :success
    assert_select('div[data-parto-items]')
  end

  test 'displays future closing time when intermediate enabled' do
    @choice.update_attributes(intermediate: true)
    get result_choice_path(id: @choice.read_token)
    assert_response :success
    assert_select('p', /Intermediate results. This choice will close in/)
  end

  test 'displays closed when closing time has passed' do
    travel_to(@choice.deadline + 1.second) do
      get result_choice_path(id: @choice.read_token)
      assert_response :success
      assert_select('p', /This choice has closed to further responses/)
    end
  end

  test 'displays closing time when intermediate result disabled' do
    get result_choice_path(id: @choice.read_token)
    assert_response :success
    assert_select('p', /Results of this choice will become available in/)
  end
end
