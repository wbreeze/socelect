require 'test_helper'

class Choice::CreateTest < ActionDispatch::IntegrationTest
  include DateTimeDisplayHelper

  test 'records opt-in for show intermediate results' do
    get new_choice_path
    assert_response :success
    assert_select 'h3', 'Options'
    assert_select 'input[name="choice[intermediate]"]'
    choice = create_full_choice(intermediate: true)
    post choices_path(params: choice_params(choice))
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Will show intermediate results'
  end

  test 'reverses opt-in for show intermediate results' do
    choice = create_full_choice(intermediate: true)
    choice.save!
    get edit_choice_path(id: choice.edit_token)
    assert_response :success
    choice.intermediate = false
    post choices_path(params: choice_params(choice))
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Results hidden until choice closes'
  end

  test 'records opt-in for make public' do
    get new_choice_path
    assert_response :success
    assert_select 'h3', 'Options'
    assert_select 'input[name="choice[public]"]'
    choice = create_full_choice(public: true)
    post choices_path(params: choice_params(choice))
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Will show publicly'
  end

  test 'reverses opt-in for make public' do
    choice = create_full_choice(public: true)
    choice.save!
    get edit_choice_path(id: choice.edit_token)
    assert_response :success
    choice.public = false
    post choices_path(params: choice_params(choice))
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Not shown publicly'
  end

  test 'records selected opening date and time' do
    choice = create_full_choice
    choice.opening = Time.now - 3.days - 2.hours
    post choices_path(params: choice_params(choice))
    assert_response :redirect
    follow_redirect!
    assert_match(datetime_full_display(choice.opening), @response.body)
  end

  test 'records selected deadline date and time' do
    choice = create_full_choice
    choice.deadline = Time.now + 1.week + 6.hours
    post choices_path(params: choice_params(choice))
    assert_response :redirect
    follow_redirect!
    assert_match(datetime_full_display(choice.deadline), @response.body)
  end
end
