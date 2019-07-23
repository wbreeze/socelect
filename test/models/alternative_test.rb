require 'test_helper'

class AlternativeTest < ActiveSupport::TestCase
  setup do
    @choice = create_full_choice
  end

  test 'validates non-empty title or description' do
    @choice.alternatives.build(title: '', description: '')
    assert_invalid_record(@choice,
      /Title or description must contain some text/)
  end

  test 'validates title length' do
    @choice.alternatives.build(title: 'A', description: '')
    assert_invalid_record(@choice,
      /Provide at least .+ characters for title or description/)
  end

  test 'allows short alternative titles' do
    @choice.alternatives.build(title: 'Beer')
    @choice.alternatives.build(title: 'Pizza')
    @choice.alternatives.build(title: 'Ale')
    @choice.alternatives.build(title: 'Fainá')
    assert(@choice.save)
  end
end
