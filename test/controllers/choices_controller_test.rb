require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  setup do
    @choice = create_full_choice
    @choice.save!
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
    assert_response :redirect
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

  test "should accept valid edit token on update choice" do
    patch_params = choice_params(@choice)
    patch_params[:id] = @choice.id
    patch :update, params: patch_params
    assert_response :redirect
    assert_redirected_to wrap_choice_path(@choice.edit_token)

    patch_params[:id] = @choice.to_param
    patch :update, params: patch_params
    assert_response :redirect
    assert_redirected_to wrap_choice_path(@choice.edit_token)

    patch_params[:id] = @choice.read_token
    patch :update, params: patch_params
    assert_response :bad_request

    patch_params[:id] = @choice.edit_token
    patch :update, params: patch_params
    assert_response :bad_request
  end

  test "should reject invalid edit token on update choice" do
    patch_params = choice_params(@choice)
    patch_params[:id] = @choice.id
    patch_params[:choice][:edit_token] = 'bad_token'
    patch :update, params: patch_params
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
