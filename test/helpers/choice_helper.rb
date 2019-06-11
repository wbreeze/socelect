module ChoiceHelper
  def create_choice(title = 'this is a choice?')
    Choice.new(title: title)
  end

  def build_alternatives(choice)
    titles = ['this is an alternative', 'this is another']
    titles.each do |title|
      choice.alternatives.build(title: title)
    end
    choice
  end

  def create_full_choice(attribs = { title: 'this is a choice?' })
    ch = Choice.new(attribs)
    build_alternatives(ch)
  end
end

class ActiveSupport::TestCase
  include ChoiceHelper
end
