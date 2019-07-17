# Test view preference by partial ordering
require 'test_helper'

class PartoDisplayTest < ActionDispatch::IntegrationTest
  setup do
    @choice = create_full_choice({}, 12)
    @choice.save!
    post preferences_path(parto_selection_params(@choice))
    assert_response :redirect
    follow_redirect!
  end

  test "post redirects to view" do
    assert_response :success
    assert_select('div[data-parto-display]')
  end

  test "view contains items" do
    assert_response :success
    assert_select('div[data-parto-display]') do
      assert_select('div[data-parto-items]')
      @choice.alternatives.each do |alt|
        assert_select("div:match('data-parto-display', ?)", /#{alt.id}/)
        assert_select("div:match('data-parto-items', ?)", /#{alt.id}/)
        assert_select("div:match('data-parto-items', ?)", /#{alt.title}/)
      end
    end
  end
end
