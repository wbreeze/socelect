# Test post preference by partial ordering
require 'test_helper'

class PartoPreferenceTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice({}, 12)
    @choice.save!
  end

  test "post returns redirect" do
    post preferences_path(parto_selection_params(@choice))
    assert_response :redirect
    follow_redirect!
  end

  test "adds a preference to choice" do
    post preferences_path(parto_selection_params(@choice))
    assert_equal(1, @choice.preferences.count)
  end

  test "preference ranks all alternatives" do
    post preferences_path(parto_selection_params(@choice))
    preference = @choice.preferences.first
    assert_equal(@choice.alternatives.count, preference.expressions.count)
  end

  test "expression of no preference has correct sequence labels" do
    params = parto_selection_params(@choice)
    post preferences_path(params)
    preference = @choice.preferences.first
    parto = JSON.parse(params[:choice][:parto])
    parto[0].each do |ids|
      expression = preference.expressions.where(alternative_id: ids.to_i)
      assert_equal(1, expression.count)
      assert_equal(1, expression.first.sequence)
    end
  end

  test "expressions have correct sequence labels" do
    alt_ids = @choice.alternatives.collect(&:id).shuffle
    parto = alt_ids.collect(&:to_s)
    post preferences_path(parto_selection_params(@choice, parto))
    preference = @choice.preferences.first
    parto.each_with_index do |ids, rank|
      expression = preference.expressions.where(alternative_id: ids.to_i)
      assert_equal(1, expression.count)
      assert_equal(rank+1, expression.first.sequence)
    end
  end
end
