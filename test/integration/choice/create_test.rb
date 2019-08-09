require 'test_helper'

class Choice::CreateTest < ActionDispatch::IntegrationTest
  include DateTimeDisplayHelper

  test 'creates new choice and alternatives' do
    params = choice_params_with_alternatives_attributes
    post choices_path, params: { choice: params }
    assert_response :redirect
    follow_redirect!

    assert_select 'div.choiceTitle', params[:title]
    assert_select 'div.choiceDescription', params[:description]
    assert_select 'div.alternatives' do
      params[:alternatives_attributes].each do |alt|
        assert_select 'div.alternativeTitle', alt[:title]
        assert_select 'div.alternativeDescription', alt[:description]
      end
    end
  end

  test 'contains opt-in for show intermediate results' do
    get new_choice_path
    assert_response :success
    assert_select 'h3', 'Options'
    assert_select 'input[name="choice[intermediate]"]'
  end

  test 'records opt-in for show intermediate results' do
    post choices_path, params: {
      choice: choice_params_with_alternatives_attributes(intermediate: true)
    }
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Will show intermediate results'
  end

  test 'reverses opt-in for show intermediate results' do
    params = choice_params_with_alternatives_attributes(intermediate: true)
    choice = create_full_choice(params)
    choice.save!
    get edit_choice_path(id: choice.edit_token)
    assert_response :success
    assert_select 'input#choice_intermediate[checked="checked"]'

    params[:intermediate] = false
    patch choice_path(id: choice.edit_token), params: { choice: params }
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Results hidden until choice closes'
  end

  test 'contains opt-in for make public' do
    get new_choice_path
    assert_response :success
    assert_select 'h3', 'Options'
    assert_select 'input[name="choice[public]"]'
    choice = create_full_choice(public: true)
  end

  test 'records opt-in for make public' do
    post choices_path, params: {
      choice: choice_params_with_alternatives_attributes(public: true)
    }
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Will show publicly'
  end

  test 'reverses opt-in for make public' do
    params = choice_params_with_alternatives_attributes(public: true)
    choice = create_full_choice(params)
    choice.save!
    get edit_choice_path(id: choice.edit_token)
    assert_response :success
    assert_select 'input#choice_public[checked="checked"]'

    params[:public] = false
    patch choice_path(id: choice.edit_token), params: { choice: params }
    assert_response :redirect
    follow_redirect!
    assert_select 'li', 'Not shown publicly'
  end

  test 'records selected opening date and time' do
    opening = Time.now.utc.beginning_of_minute - 3.days - 2.hours
    params = choice_params_with_alternatives_attributes({
      opening_date: date_str(opening),
      opening_time: time_str(opening)
    })

    post choices_path, params: { choice: params }
    assert_response :redirect
    follow_redirect!
    assert_match(datetime_full_display(opening), @response.body)
  end

  test 'records selected deadline date and time' do
    deadline = Time.now.utc.beginning_of_minute + 1.week + 6.hours
    params = choice_params_with_alternatives_attributes({
      deadline_date: date_str(deadline),
      deadline_time: time_str(deadline)
    })

    post choices_path, params: { choice: params }
    assert_response :redirect
    follow_redirect!
    assert_match(datetime_full_display(deadline), @response.body)
  end
end
