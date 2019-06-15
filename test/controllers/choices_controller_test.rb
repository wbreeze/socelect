require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
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

  def selection_params(choice)
    alt_id = choice.alternatives[rand(choice.alternatives.count)].id
    {
      id: choice.read_token,
      alternative: alt_id,
      commit: 'Submit preference',
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

  test "should show choice only by read token" do
    get :show, params: { id: @choice.id }
    assert_response :not_found
    get :show, params: { id: @choice.to_param }
    assert_response :not_found
    get :show, params: { id: @choice.read_token }
    assert_response :success
    get :show, params: { id: @choice.edit_token }
    assert_response :not_found
  end

  test "should get edit only by edit token" do
    get :edit, params: { id: @choice.id }
    assert_response :not_found
    get :edit, params: { id: @choice.to_param }
    assert_response :not_found
    get :edit, params: { id: @choice.read_token }
    assert_response :not_found
    get :edit, params: { id: @choice.edit_token }
    assert_response :success
  end

  test "should update choice only by edit token" do
    put :update, params: { id: @choice.id, choice: @choice.attributes }
    assert_response :bad_request
    put :update, params: { id: @choice.to_param, choice: @choice.attributes }
    assert_response :bad_request
    put :update, params: { id: @choice.read_token, choice: @choice.attributes }
    assert_response :bad_request
    put :update, params: { id: @choice.edit_token, choice: @choice.attributes }
    assert_response :success
  end

  test 'should post selection only by read token' do
    params = selection_params(@choice)
    post :selection, params: params
    assert_response :found
    params[:id] = @choice.id
    post :selection, params: params
    assert_response :bad_request
    params[:id] = @choice.edit_token
    post :selection, params: params
    assert_response :bad_request
  end

  test "should show result only by read token" do
    get :result, params: { id: @choice.id }
    assert_response :not_found
    get :result, params: { id: @choice.to_param }
    assert_response :not_found
    get :result, params: { id: @choice.read_token }
    assert_response :success
    get :result, params: { id: @choice.edit_token }
    assert_response :not_found
  end

  test "should show wrap-up only by edit token" do
    get :wrap, params: { id: @choice.id }
    assert_response :not_found
    get :wrap, params: { id: @choice.to_param }
    assert_response :not_found
    get :wrap, params: { id: @choice.read_token }
    assert_response :not_found
    get :wrap, params: { id: @choice.edit_token }
    assert_response :success
  end
end
