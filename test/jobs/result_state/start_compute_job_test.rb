require 'test_helper'

# There is no state change with this job. It is a liveness signal that
#   ensures dirty jobs are eventually computed.
# Like NewPrefJob, it queues a compute job for the choice if it is dirty.
class ResultState::StartComputeJobTest < ActiveJob::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
  end

  test 'dirty choice queues compute job' do
    skip(
      "Why does not ResultState::ComputeJob.perform_later(choice) queue a job?"
    )
    @choice.result_dirty!
    @choice.save!
    assert_enqueued_with(
      job: ResultState::ComputeJob, args: [@choice], queue: :result_compute
    ) do
      ResultState::StartComputeJob.perform_now(@choice)
    end
    assert(@choice.reload.result_dirty?)
  end

  test 'computed @choice does not queue a job' do
    assert(@choice.result_computed?)
    assert_no_enqueued_jobs(only: ResultState::ComputeJob) do
      ResultState::StartComputeJob.perform_now(@choice)
    end
    assert(@choice.reload.result_computed?)
  end

  test 'computing @choice does not queue a job' do
    @choice.result_computing!
    @choice.save!
    assert_no_enqueued_jobs(only: ResultState::ComputeJob) do
      ResultState::StartComputeJob.perform_now(@choice)
    end
    assert(@choice.reload.result_computing?)
  end

  test 'computing_dirty @choice does not queue a job' do
    @choice.result_computing_dirty!
    @choice.save!
    assert_no_enqueued_jobs(only: ResultState::ComputeJob) do
      ResultState::StartComputeJob.perform_now(@choice)
    end
    assert(@choice.reload.result_computing_dirty?)
  end
end
