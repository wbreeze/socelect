require 'test_helper'

class ValidTitlesTest < ActiveSupport::TestCase
  test "validate description no title" do
    desc = 'the description field'
    ch = create_full_choice({:title => '', :description => desc})
    assert(ch.save)
    assert_equal(desc, ch.title)
  end

  test "validate no description or title" do
    ch = create_full_choice({:title => '', :description => ''})
    assert_invalid_record(ch, 'must contain some text')
  end

  test "substring description for title" do
    ch = create_full_choice({
      title: '',
      description: 'This is a not. This is a question?  This is not either.'
    })
    assert(ch.save)
    assert_equal('This is a question?', ch.title)
  end

  test "validate short title no description" do
    ch = create_full_choice({:title => 'short', :description => ''})
    assert_invalid_record(ch, /Provide at least .+ for title or description/)
  end

  test "validate short title some description" do
    ch = create_full_choice({
      title: 'short', description: 'some description'
    })
    assert(ch.save)
    assert_equal('short', ch.title);
  end

  test "validate short title short description" do
    ch = create_full_choice({:title => 'short', :description => 'desc'})
    assert_invalid_record(ch, /Provide at least .+ for title or description/)
  end

  test "validate title yes not sufficient" do
    ch = create_full_choice({:title => 'yes', :description => ''})
    assert_invalid_record(ch, /Provide at least .+ for title or description/)
  end
end
