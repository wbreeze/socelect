# Used  by ChoicesController#new to set-up initial, blank alternatives

module Choice::EnsureAlternatives
  def ensure_two_alternatives
    while alternatives.size < 2 do
      alternatives.build
    end
  end
end
