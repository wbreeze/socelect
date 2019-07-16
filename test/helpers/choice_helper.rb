module ChoiceHelper
  def create_choice(title = 'this is a choice?')
    Choice.new(title: title)
  end

  def build_alternatives(choice, count=2)
    titles = Array.new(count).collect do
      Faker::Book.unique.title
    end
    titles.each do |title|
      choice.alternatives.build(title: title)
    end
    choice
  end

  def create_full_choice(attribs = { title: 'this is a choice?' })
    ch = Choice.new(attribs)
    build_alternatives(ch)
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
