module DateTimeDisplayHelper
  include ActionView::Helpers::DateHelper

  def datetime_formatted(datetime)
    datetime.strftime('%a, %-d %b %Y, %H:%M %Z')
  end

  def label_formatted(label)
    label.blank? ? '' : label + ' '
  end

  def datetime_labeled(datetime, label=nil, past_label=nil)
    if (label || past_label)
      now = Time.now
      if datetime < now
        label_formatted(past_label) + datetime_formatted(datetime)
      else
        label_formatted(label) + datetime_formatted(datetime)
      end
    else
      datetime_formatted(datetime)
    end
  end

  def datetime_distance(datetime, label=nil, past_label=nil)
    now = Time.now
    if datetime < now
      label_formatted(past_label) +
      distance_of_time_in_words(now, datetime) +
      ' ago'
    elsif now < datetime
      label_formatted(label) +
      'in ' +
      distance_of_time_in_words(datetime, now)
    else
      label_formatted(label) + 'now'
    end
  end

  def datetime_full_display(datetime, label=nil, past_label=nil)
    datetime_labeled(datetime, label, past_label) +
    ", " +
    datetime_distance(datetime)
  end
end
