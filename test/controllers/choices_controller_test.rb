require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create choice" do
    assert_difference('Choice.count') do
      post :create,
        params: { choice: choice_params_with_alternatives_attributes }
    end
    assert_response :redirect
  end

  test "should show choice only by read token" do
    choice = create_full_choice
    choice.save!
    get :show, params: { id: choice.id }
    assert_response :not_found
    get :show, params: { id: choice.to_param }
    assert_response :not_found
    get :show, params: { id: choice.read_token }
    assert_response :success
    get :show, params: { id: choice.edit_token }
    assert_response :not_found
  end

  test "should get edit only by edit token" do
    choice = create_full_choice
    choice.save!
    get :edit, params: { id: choice.id }
    assert_response :not_found
    get :edit, params: { id: choice.to_param }
    assert_response :not_found
    get :edit, params: { id: choice.read_token }
    assert_response :not_found
    get :edit, params: { id: choice.edit_token }
    assert_response :success
  end

  test "should accept valid edit token on update choice" do
    patch_params = { choice: choice_params_with_alternatives_attributes }
    choice = Choice::Edit.new(patch_params[:choice])
    choice.save!

    patch_params[:id] = choice.id
    patch :update, params: patch_params
    assert_response :redirect
    assert_redirected_to wrap_choice_path(choice.edit_token)

    patch_params[:id] = choice.to_param
    patch :update, params: patch_params
    assert_response :redirect
    assert_redirected_to wrap_choice_path(choice.edit_token)

    patch_params[:id] = choice.read_token
    patch :update, params: patch_params
    assert_response :bad_request

    patch_params[:id] = choice.edit_token
    patch :update, params: patch_params
    assert_response :redirect
    assert_redirected_to wrap_choice_path(choice.edit_token)
  end

  test "should reject invalid edit token on update choice" do
    patch_params = { choice: choice_params_with_alternatives_attributes }
    patch_params[:id] = 'bad_token'
    patch :update, params: patch_params
    assert_response :bad_request
  end

  test "should show result only by read token" do
    choice = create_full_choice
    choice.save!
    get :result, params: { id: choice.id }
    assert_response :not_found
    get :result, params: { id: choice.to_param }
    assert_response :not_found
    get :result, params: { id: choice.read_token }
    assert_response :success
    get :result, params: { id: choice.edit_token }
    assert_response :not_found
  end

  test "should show wrap-up only by edit token" do
    choice = create_full_choice
    choice.save!
    get :wrap, params: { id: choice.id }
    assert_response :not_found
    get :wrap, params: { id: choice.to_param }
    assert_response :not_found
    get :wrap, params: { id: choice.read_token }
    assert_response :not_found
    get :wrap, params: { id: choice.edit_token }
    assert_response :success
  end
end
