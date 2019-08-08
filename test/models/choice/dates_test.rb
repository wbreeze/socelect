require 'test_helper'

class DatesTest < ActiveSupport::TestCase
  DT_FORMAT = '%Y-%ms%d %H:%M %z'

  test 'create has default start and end dates' do
    freeze_time do
      now = Time.now.utc
      ch = create_full_choice
      assert_equal(now.strftime(DT_FORMAT), ch.opening.strftime(DT_FORMAT))
      assert(now < ch.deadline)
    end
  end

  test 'save writes opening and deadline date and time' do
    ts = Time.now.utc + 1.day
    te = Time.now.utc + 2.days
    ch = create_full_choice
    ch.opening = ts
    ch.deadline = te
    assert(ch.save)
    id = ch.id
    ch = Choice.find(id)
    assert_equal(ts.strftime(DT_FORMAT), ch.opening.strftime(DT_FORMAT))
    assert_equal(te.strftime(DT_FORMAT), ch.deadline.strftime(DT_FORMAT))
  end
end
