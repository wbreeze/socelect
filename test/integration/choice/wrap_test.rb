require 'test_helper'

class WrapTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice
    @choice.save!
    get wrap_choice_path(@choice.edit_token)
    assert_response :success
  end

  test "wrap has edit link" do
    assert_match(edit_choice_path(@choice.edit_token), @response.parsed_body)
  end

  test "wrap has view link" do
    assert_match(choice_path(@choice.read_token), @response.parsed_body)
  end

  test "wrap has result link" do
    assert_match(result_choice_path(@choice.read_token), @response.parsed_body)
  end
end
