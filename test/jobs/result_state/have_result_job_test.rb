require 'test_helper'

class ResultState::HaveResultJobTest < ActiveJob::TestCase
  test "the truth" do
    assert true
  end

  def setup
    @choice = create_full_choice
    @choice.save!
    @parto = JSON.generate(@choice.alternatives.collect do |alt|
      [alt.id]
    end)
  end

  test 'from computed to computed' do
    assert(@choice.result_computed?)
    ResultState::HaveResultJob.perform_now(@choice, @parto)
    assert(@choice.result_computed?)
    assert_equal(@parto, @choice.result_parto)
  end

  test 'from dirty to dirty' do
    @choice.result_dirty!
    @choice.save!
    ResultState::HaveResultJob.perform_now(@choice, @parto)
    assert(@choice.result_dirty?)
    assert_equal(@parto, @choice.result_parto)
  end

  test 'from computing to computed' do
    @choice.result_computing!
    @choice.save!
    ResultState::HaveResultJob.perform_now(@choice, @parto)
    assert(@choice.result_computed?)
    assert_equal(@parto, @choice.result_parto)
  end

  test 'from computing_dirty to dirty' do
    @choice.result_computing_dirty!
    @choice.save!
    ResultState::HaveResultJob.perform_now(@choice, @parto)
    assert(@choice.result_dirty?)
    assert_equal(@parto, @choice.result_parto)
  end
end
