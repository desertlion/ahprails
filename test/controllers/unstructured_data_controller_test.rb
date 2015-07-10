require 'test_helper'

class UnstructuredDataControllerTest < ActionController::TestCase
  setup do
    @unstructured_datum = unstructured_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unstructured_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unstructured_datum" do
    assert_difference('UnstructuredDatum.count') do
      post :create, unstructured_datum: { name: @unstructured_datum.name, subcriterium_id: @unstructured_datum.subcriterium_id }
    end

    assert_redirected_to unstructured_datum_path(assigns(:unstructured_datum))
  end

  test "should show unstructured_datum" do
    get :show, id: @unstructured_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unstructured_datum
    assert_response :success
  end

  test "should update unstructured_datum" do
    patch :update, id: @unstructured_datum, unstructured_datum: { name: @unstructured_datum.name, subcriterium_id: @unstructured_datum.subcriterium_id }
    assert_redirected_to unstructured_datum_path(assigns(:unstructured_datum))
  end

  test "should destroy unstructured_datum" do
    assert_difference('UnstructuredDatum.count', -1) do
      delete :destroy, id: @unstructured_datum
    end

    assert_redirected_to unstructured_data_path
  end
end
