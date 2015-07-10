require 'test_helper'

class SubcriteriaControllerTest < ActionController::TestCase
  setup do
    @subcriterium = subcriteria(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subcriteria)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subcriterium" do
    assert_difference('Subcriterium.count') do
      post :create, subcriterium: { criteria_id: @subcriterium.criteria_id, name: @subcriterium.name }
    end

    assert_redirected_to subcriterium_path(assigns(:subcriterium))
  end

  test "should show subcriterium" do
    get :show, id: @subcriterium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subcriterium
    assert_response :success
  end

  test "should update subcriterium" do
    patch :update, id: @subcriterium, subcriterium: { criteria_id: @subcriterium.criteria_id, name: @subcriterium.name }
    assert_redirected_to subcriterium_path(assigns(:subcriterium))
  end

  test "should destroy subcriterium" do
    assert_difference('Subcriterium.count', -1) do
      delete :destroy, id: @subcriterium
    end

    assert_redirected_to subcriteria_path
  end
end
