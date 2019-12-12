class ResultState::HaveResultJob < ApplicationJob
  queue_as :result_state

  def perform(choice, parto)
    choice.result_parto = parto
    case
    when choice.result_computing?
      choice.result_computed!
    when choice.result_computing_dirty?
      choice.result_dirty!
    end
    choice.save!
  end
end
