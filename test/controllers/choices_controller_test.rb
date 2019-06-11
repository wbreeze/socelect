require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  setup do
    @choice = choices(:one)
  end

  def choice_params(choice)
    {
      choice: {
        title: choice.title,
        description: choice.description,
        opening_date: choice.opening.to_date,
        opening_time: choice.opening.to_time,
        deadline_date: choice.deadline.to_date,
        deadline_time: choice.deadline.to_time,
        alternatives_attributes: choice.alternatives.collect do |alt|
          {
            title: alt.title,
            description: alt.description
          }
        end
      }
    }
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create choice" do
    more_choice = create_full_choice
    assert_difference('Choice.count') do
      post :create, params: choice_params(more_choice)
    end
    assert_response :success
  end

  test "should show choice" do
    get :show, params: { id: @choice.to_param }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @choice.to_param }
    assert_response :success
  end

  test "should update choice" do
    put :update, params: {
      id: @choice.to_param,
      choice: @choice.attributes
    }
    assert_response :success
  end
end
