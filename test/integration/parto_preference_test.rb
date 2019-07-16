# Test post preference by partial ordering
require 'test_helper'

class PartoPreferenceTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_choice("#{Faker::Book.author} books")
    build_alternatives(@choice, 12)
    @choice.save!
    params = parto_selection_params(@choice)
    @parto = JSON.parse(params[:choice][:parto])
    post preferences_path(params)
    assert_response :redirect
    follow_redirect!
  end

  test "adds a preference to choice" do
    assert_equal(1, @choice.preferences.count)
  end

  test "preference ranks all alternatives" do
    preference = @choice.preferences.first
    assert_equal(@choice.alternatives.count, preference.expressions.count)
  end

  test "expressions have correct sequence labels" do
    preference = @choice.preferences.first
    @parto[0].each_with_index do |ids, rank|
      expression = preference.expressions.where(alternative_id: ids.to_i)
      assert_equal(1, expression.count)
      assert_equal(rank+1, expression.first.sequence)
    end
  end
end
