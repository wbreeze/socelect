class ResultState::NewPrefJob < ApplicationJob
  queue_as :result_state

  # choice is an instance of the Choice class (via GlabalID)
  def perform(choice)
    case
    when choice.result_computed?
      # queue computation job. regardless of successful
      choice.result_dirty!
      choice.save!
    when choice.result_computing?
      choice.result_computing_dirty!
      choice.save!
    end
  end
end
