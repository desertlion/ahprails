require 'test_helper'

class CriteriaControllerTest < ActionController::TestCase
  setup do
    @criterium = criteria(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:criteria)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create criterium" do
    assert_difference('Criterium.count') do
      post :create, criterium: { name: @criterium.name }
    end

    assert_redirected_to criterium_path(assigns(:criterium))
  end

  test "should show criterium" do
    get :show, id: @criterium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @criterium
    assert_response :success
  end

  test "should update criterium" do
    patch :update, id: @criterium, criterium: { name: @criterium.name }
    assert_redirected_to criterium_path(assigns(:criterium))
  end

  test "should destroy criterium" do
    assert_difference('Criterium.count', -1) do
      delete :destroy, id: @criterium
    end

    assert_redirected_to criteria_path
  end
end
