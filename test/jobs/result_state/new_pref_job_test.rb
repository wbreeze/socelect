require 'test_helper'

class ResultState::NewPrefJobTest < ActiveJob::TestCase
  test "the truth" do
    assert true
  end

  def setup
    @choice = create_full_choice
    @choice.save!
  end

  test 'from computed to dirty' do
    assert(@choice.result_computed?)
    ResultState::NewPrefJob.perform_now(@choice)
    assert(@choice.result_dirty?)
  end

  test 'from dirty to dirty' do
    @choice.result_dirty!
    @choice.save!
    ResultState::NewPrefJob.perform_now(@choice)
    assert(@choice.result_dirty?)
  end

  test 'from computing to computing_dirty' do
    @choice.result_computing!
    @choice.save!
    ResultState::NewPrefJob.perform_now(@choice)
    assert(@choice.result_computing_dirty?)
  end

  test 'from computing_dirty to computing_dirty' do
    @choice.result_computing_dirty!
    @choice.save!
    ResultState::NewPrefJob.perform_now(@choice)
    assert(@choice.result_computing_dirty?)
  end
end
