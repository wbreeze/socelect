require 'test_helper'

class ValidAlternativesTest < ActiveSupport::TestCase
  test "validate two alternatives" do
    ch = create_choice
    assert_invalid_record(ch, 'two alternatives')
    build_alternatives(ch, 1)
    assert_invalid_record(ch, 'two alternatives')
    build_alternatives(ch, 1)
    assert(ch.save)
  end

  test "validate yes and no alternatives" do
    ch = Choice.new({:title => 'Do you like lobster?', :description => ''})
    yes = 'yes'
    no = 'No'
    ch.alternatives.build(title: yes)
    ch.alternatives.build(title: no)
    assert(ch.save)
    alts = ch.alternatives
    assert_equal(yes, alts[0].title)
    assert_equal(no, alts[1].title)
  end

  test 'create does not add alternatives' do
    ch = Choice.new({title: 'Choice title'})
    assert_equal(0, ch.alternatives.size)
    assert_invalid_record(ch, 'two alternatives')
  end
end
