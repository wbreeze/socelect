require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  test 'new choice has good result' do
    ch = create_full_choice
    ch.save!
    assert(ch.result_computed?)
  end

  test 'new choice returns no-order result' do
    ch = create_full_choice
    ch.save!
    r = ch.result_parto
    refute_nil(r)
    ra = JSON.parse(r)
    p = ch.alternatives.collect(&:id)
    assert_equal(p.sort, ra.sort)
  end
end
