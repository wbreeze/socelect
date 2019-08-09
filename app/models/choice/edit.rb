# Used  by ChoicesController#edit, update

class Choice::Edit < ActiveType::Record[Choice]
  include DateTimeDisplayHelper

  attr_accessor :opening_date, :opening_time, :deadline_date, :deadline_time

  before_validation :resolve_dates
  validate do
    errors.add(
      :deadline, "should be more than a minute in the future"
    ) unless Time.now.utc + 1.minute < deadline
  end
  validate do
    errors.add(
      :opening, "should be more than a minute before the closing"
    ) unless opening + 1.minute < deadline
  end

  # override to_param to be the edit token, so as not to expose the id
  def to_param
    edit_token
  end

  def opening
    super || Time.now.utc.beginning_of_minute
  end

  def deadline
    super || opening + 1.day
  end

  def opening_date
    @opening_date ||= date_str(opening)
  end

  def opening_time
    @opening_time ||= time_str(opening)
  end

  def deadline_date
    @deadline_date ||= date_str(deadline)
  end

  def deadline_time
    @deadline_time ||= time_str(deadline)
  end

  def resolve_date_and_time(date_value, time_value, default=Time.now.utc)
    dd = date_value.to_datetime || default
    dt = time_value.to_datetime || default
    DateTime.new(
      dd.year, dd.month, dd.day, dt.hour, dt.min
    ).utc.beginning_of_minute
  end

  def resolve_dates
    self.opening = resolve_date_and_time(
      self.opening_date, self.opening_time, self.opening)
    self.deadline = resolve_date_and_time(
      self.deadline_date, self.deadline_time, self.deadline)
  end
end
