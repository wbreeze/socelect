class ResultState::StartComputeJob < ApplicationJob
  queue_as :result_state

  def perform(choice)
    ResultState::ComputeJob.perform_later(choice) if choice.result_dirty?
  end
end
