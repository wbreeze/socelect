# Used  by ChoicesController#new (only!) to set-up initial, blank alternatives

class Choice::EnsureAlternatives < Choice::Edit
  after_initialize do |choice|
    while choice.alternatives.size < 2 do
      choice.alternatives.build
    end
  end
end
