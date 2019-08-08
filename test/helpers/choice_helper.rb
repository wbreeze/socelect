module ChoiceHelper
  include DateTimeDisplayHelper

  def create_choice(attribs={})
    opening = Time.now.utc.beginning_of_minute
    choice_attrs = choice_params(attribs).merge({
      opening: opening,
      deadline: opening + 1.day
    }).reject do |key|
      %i[opening_date opening_time deadline_date deadline_time].include?(key)
    end
    Choice.new(choice_attrs)
  end

  def build_alternatives(choice, alt_ct=2)
    alt_ct.times do
      choice.alternatives.build(alternative_params)
    end
    choice
  end

  def create_full_choice(attribs={}, alt_ct=2)
    choice = create_choice(attribs)
    alt_ct = 2 if alt_ct < 2
    build_alternatives(choice, alt_ct)
  end

  def alternative_params
    {
      title: Faker::Book.unique.title,
      description: Faker::Quote.most_interesting_man_in_the_world
    }
  end

  def choice_params_with_alternatives_attributes(choice_attrs = {}, alt_ct = 2)
    attrs = choice_params.merge(choice_attrs)
    attrs[:alternatives_attributes] = alt_ct.times.collect do
      alternative_params
    end
    attrs
  end

  def choice_params(attrs = {})
    opening = Time.now.utc
    deadline = opening + 1.day
    {
      title: Faker::Book.unique.title,
      description: Faker::Quote.yoda,
      opening_date: date_str(opening),
      opening_time: time_str(opening),
      deadline_date: date_str(deadline),
      deadline_time: time_str(deadline),
      intermediate: false,
      public: false
    }.merge(attrs)
  end

  def selection_params(choice, alt_id = nil)
    alt_id ||= choice.alternatives[rand(choice.alternatives.count)].id
    {
      choice: {
        read_token: choice.read_token,
      },
      alternative: alt_id,
      commit: 'Submit preference',
    }
  end

  def parto_selection_params(choice, parto = nil)
    unless parto
      alt_ids = choice.alternatives.collect(&:id).shuffle
      parto = [alt_ids.collect(&:to_s)]
    end
    {
      choice: {
        read_token: choice.read_token,
        parto: parto.to_json
      },
      commit: 'Submit preference',
    }
  end
end

class ActiveSupport::TestCase
  include ChoiceHelper
end
