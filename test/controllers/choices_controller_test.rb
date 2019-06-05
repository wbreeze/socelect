require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  setup do
    @choice = choices(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create choice" do
    assert_difference('Choice.count') do
      post :create, params: { choice: @choice.attributes }
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
