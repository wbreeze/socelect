require 'test_helper'

class SlugsTest < ActiveSupport::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
  end

  test 'generates read slug on first save' do
    refute_nil(@choice.id)
    refute_nil(@choice.read_slug)
  end

  test 'generates edit slug on first save' do
    refute_nil(@choice.id)
    refute_nil(@choice.edit_slug)
  end

  test 'does not alter slug on subsequent save' do
    edit_slug = @choice.edit_slug
    read_slug = @choice.read_slug
    @choice.title = 'And when you write, do you change?'
    @choice.save!
    assert_equal(edit_slug, @choice.edit_slug)
    assert_equal(read_slug, @choice.read_slug)
  end
end
