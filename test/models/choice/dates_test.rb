require 'test_helper'

class DatesTest < ActiveSupport::TestCase
  test 'create has default start and end dates' do
    now = DateTime.current
    Timecop.freeze now do
      ch = create_full_choice
      dt_format = '%Y:%m:%d:%H:%M:%S:%z'
      d_format = '%Y:%m:%d'
      t_format = '%H:%M:%S:%z'
      assert_equal(now.strftime(dt_format), ch.opening.strftime(dt_format))
      assert_equal(ch.opening.strftime(d_format),
        ch.opening_date.strftime(d_format))
      assert_equal(ch.opening.to_time.strftime(t_format),
        ch.opening_time.strftime(t_format))
      assert(now < ch.deadline)
      assert(now.to_date < ch.deadline_date)
      assert_equal(ch.deadline.strftime(d_format),
        ch.deadline_date.strftime(d_format))
      assert_equal(ch.deadline.to_time.strftime(t_format),
        ch.deadline_time.strftime(t_format))
      assert_equal(now.to_time.strftime(t_format),
        ch.deadline_time.strftime(t_format))
    end
  end

  test 'save writes opening and deadline date and time' do
    ts = DateTime.current + 1.day
    te = DateTime.current + 2.days
    ch = create_full_choice
    ch.opening_date = Date.new(ts.year, ts.month, ts.day)
    ch.opening_time = DateTime.new(ts.year, ts.month, ts.day, ts.hour, ts.minute)
    ch.deadline_date = Date.new(te.year, te.month, te.day)
    ch.deadline_time = DateTime.new(te.year, te.month, te.day, te.hour, te.minute)
    assert(ch.save)
    id = ch.id
    ch = Choice.find(id)
    assert_equal(ts.hour, ch.opening.hour)
    assert_equal(ts.min, ch.opening.min)
    assert_equal(ts.day, ch.opening.day)
    assert_equal(ts.month, ch.opening.month)
    assert_equal(ts.year, ch.opening.year)
    assert_equal(te.hour, ch.deadline.hour)
    assert_equal(te.min, ch.deadline.min)
    assert_equal(te.day, ch.deadline.day)
    assert_equal(te.month, ch.deadline.month)
    assert_equal(te.year, ch.deadline.year)
  end
end
