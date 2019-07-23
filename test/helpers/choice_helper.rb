module ChoiceHelper
  def create_choice(attribs={})
    title = attribs.fetch(:title, nil) || Faker::Book.unique.title
    description = attribs.fetch(:description, nil) || Faker::Quote.yoda
    intermediate = attribs.fetch(:intermediate, false)
    public = attribs.fetch(:public, false)
    Choice.new(
      title: title, description: description, intermediate: intermediate,
      public: public
    )
  end

  def build_alternatives(choice, count=2)
    titles = Array.new(count).collect do
      Faker::Book.unique.title
    end
    titles.each do |title|
      description = Faker::Quote.most_interesting_man_in_the_world
      alt=choice.alternatives.build(title: title, description: description)
    end
    choice
  end

  def create_full_choice(attribs={}, alt_ct=2)
    choice = create_choice(attribs)
    alt_ct = 2 if alt_ct < 2
    build_alternatives(choice, alt_ct)
  end

  def choice_params(choice)
    {
      choice: {
        title: choice.title,
        description: choice.description,
        opening_date: choice.opening.to_date,
        opening_time: choice.opening.to_time,
        deadline_date: choice.deadline.to_date,
        deadline_time: choice.deadline.to_time,
        edit_token: choice.edit_token,
        read_token: choice.read_token,
        intermediate: choice.intermediate,
        public: choice.public,
        alternatives_attributes: choice.alternatives.collect do |alt|
          {
            title: alt.title,
            description: alt.description
          }
        end
      }
    }
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
