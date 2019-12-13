class ResultState::ComputeJob < ApplicationJob
  queue_as :result_compute

  def perform(choice, computation_class_name = "DavenportComputer")
    do_compute = false
    choice.with_lock do
      # we check and then set the result_state
      do_compute = choice.result_dirty?
      if (do_compute)
        choice.result_computing!
        choice.save!
      end
    end
    if do_compute
      clazz = Object.const_get(computation_class_name)
      computer = clazz.new(choice)
      parto = computer.result_as_parto
      ResultState::HaveResultJob.perform_later(choice, parto)
    end
  end
end
