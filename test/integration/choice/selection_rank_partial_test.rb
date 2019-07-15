# Test display of choice alternatives for
# expression of preference by partial ordering
require 'test_helper'

class SelectionRankPartialTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice
    @choice.save!
    get choice_path(@choice.read_token)
    assert_response :success
  end

  test "has choice identified" do
    assert_select("input[name='choice[read_token]']") do
      assert_select("input[value='#{@choice.read_token}']");
    end
  end

  test "has stem" do
    assert_select('div[class="choiceTitle"]', @choice.title)
  end

  test "has parto input" do
    assert_select('div[data-poui-field="choice[parto]"]')
  end

  test "has alternatives" do
    @choice.alternatives.each do |alt|
      assert_select("div:match('data-poui-items', ?)", /#{alt.id}/)
      assert_select("div:match('data-poui-items', ?)", /#{alt.title}/)
    end
  end
end
