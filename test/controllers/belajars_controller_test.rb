require 'test_helper'

class BelajarsControllerTest < ActionController::TestCase
  setup do
    @belajar = belajars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:belajars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create belajar" do
    assert_difference('Belajar.count') do
      post :create, belajar: { nama: @belajar.nama, ruang: @belajar.ruang }
    end

    assert_redirected_to belajar_path(assigns(:belajar))
  end

  test "should show belajar" do
    get :show, id: @belajar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @belajar
    assert_response :success
  end

  test "should update belajar" do
    patch :update, id: @belajar, belajar: { nama: @belajar.nama, ruang: @belajar.ruang }
    assert_redirected_to belajar_path(assigns(:belajar))
  end

  test "should destroy belajar" do
    assert_difference('Belajar.count', -1) do
      delete :destroy, id: @belajar
    end

    assert_redirected_to belajars_path
  end
end
