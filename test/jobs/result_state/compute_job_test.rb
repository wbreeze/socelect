require 'test_helper'

class ResultState::ComputeJobTest < ActiveJob::TestCase
  class MockComputer
    attr_reader :choice
    cattr_reader :called, :returned, :state_at_call

    def self.parto_string(choice)
      JSON.generate(choice.alternatives.collect(&:id))
    end

    def self.reset
      @@called = false
      @@state_at_call = nil
      @@returned = nil
    end

    def initialize(choice)
      @choice = choice
    end

    def result_as_parto
      @@called = true
      @@state_at_call = choice.result_state
      @@returned = self.class.parto_string(choice)
    end
  end

  def setup
    @choice = create_full_choice
    @choice.save!
    MockComputer.reset
  end

  test 'Executes davenport on the choice if dirty' do
    @choice.result_dirty!
    @choice.save!
    ResultState::ComputeJob.perform_now(@choice,
      'ResultState::ComputeJobTest::MockComputer')
    assert(MockComputer.called)
    assert_equal(MockComputer.parto_string(@choice), MockComputer.returned)
  end

  test 'Does not execute on the choice if computed' do
    assert(@choice.result_computed?)
    ResultState::ComputeJob.perform_now(@choice,
      'ResultState::ComputeJobTest::MockComputer')
    refute(MockComputer.called)
  end

  test 'Does not execute on the choice if computing' do
    @choice.result_computing!
    @choice.save!
    ResultState::ComputeJob.perform_now(@choice,
      'ResultState::ComputeJobTest::MockComputer')
    refute(MockComputer.called)
  end

  test 'Does not execute on the choice if computing_dirty' do
    @choice.result_computing_dirty!
    @choice.save!
    ResultState::ComputeJob.perform_now(@choice,
      'ResultState::ComputeJobTest::MockComputer')
    refute(MockComputer.called)
  end

  test 'Sets choice state to computing' do
    @choice.result_dirty!
    @choice.save!
    ResultState::ComputeJob.perform_now(@choice,
      'ResultState::ComputeJobTest::MockComputer')
    assert_equal('computing', MockComputer.state_at_call)
  end

  test 'Queues computed_result job' do
    skip "Why does perform_later not queue in the compute_job?"
    assert_enqueued_with(
      job: ResultState::HaveResultJob, queue: 'result_state'
    ) do
      ResultState::ComputeJob.perform_now(@choice,
        'ResultState::ComputeJobTest::MockComputer')
    end
  end
end
