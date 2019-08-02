require 'test_helper'

class DatesTest < ActiveSupport::TestCase
  DT_FORMAT = '%Y-%ms%d %H:%M %z'
  D_FORMAT = '%Y-%m-%d'
  T_FORMAT = '%H:%M'

  test 'create has default start and end dates' do
    freeze_time do
      now = Time.now.utc
      ch = create_full_choice
      assert_equal(now.strftime(DT_FORMAT), ch.opening.strftime(DT_FORMAT))
      assert_equal(ch.opening.strftime(D_FORMAT), ch.opening_date)
      assert_equal(ch.opening.strftime(T_FORMAT), ch.opening_time)
      assert(now < ch.deadline)
      assert_equal(ch.deadline.strftime(D_FORMAT), ch.deadline_date)
      assert_equal(ch.deadline.strftime(T_FORMAT), ch.deadline_time)
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
    assert_equal(ts.strftime(D_FORMAT), ch.opening_date)
    assert_equal(ts.strftime(T_FORMAT), ch.opening_time)
    assert_equal(te.strftime(DT_FORMAT), ch.deadline.strftime(DT_FORMAT))
    assert_equal(te.strftime(D_FORMAT), ch.deadline_date)
    assert_equal(te.strftime(T_FORMAT), ch.deadline_time)
  end
end
