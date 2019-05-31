require 'test_helper'

class ChoiceTest < ActiveSupport::TestCase
  test "validate description no title" do
    desc = 'the description field'
    ch = Choice.new({:title => '', :description => desc})
    ch.ensureTwoAlternatives
    assert(ch.save)
    assert_equal(desc, ch.title)
  end

  test "validate no description or title" do
    ch = Choice.new({:title => '', :description => ''})
    ch.ensureTwoAlternatives
    refute(ch.save)
  end

  test "substring description for title" do
    ch = Choice.new({
      title: '',
      description: 'This is a not. This is a question?  This is not either.'
    })
    ch.ensureTwoAlternatives
    assert(ch.save)
    assert_equal('This is a question?', ch.title)
  end

  test "validate short title no description" do
    ch = Choice.new({:title => 'short', :description => ''})
    ch.ensureTwoAlternatives
    refute(ch.save)
  end

  test "validate short title some description" do
    ch = Choice.new({:title => 'short', :description => 'some description'})
    ch.ensureTwoAlternatives
    assert(ch.save)
    assert_equal('short', ch.title);
  end

  test "validate short title short description" do
    ch = Choice.new({:title => 'short', :description => 'desc'})
    ch.ensureTwoAlternatives
    refute(ch.save)
  end

  test "validate yes and no alternatives" do
    ch = Choice.new({:title => 'Do you like lobster?', :description => ''})
    ch.ensureTwoAlternatives
    alts = ch.alternatives
    alts[0].title = 'yes'
    alts[1].title = 'No'
    assert(ch.save)
    alts = ch.alternatives
    assert_equal('yes', alts[0].title)
    assert_equal('No', alts[1].title)
  end

  test "validate title yes not sufficient" do
    ch = Choice.new({:title => 'yes', :description => ''})
    ch.ensureTwoAlternatives
    refute(ch.save)
  end

end
