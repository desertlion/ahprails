require 'test_helper'

class AbsensControllerTest < ActionController::TestCase
  setup do
    @absen = absens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:absens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create absen" do
    assert_difference('Absen.count') do
      post :create, absen: { alamat: @absen.alamat, nama: @absen.nama, nim: @absen.nim }
    end

    assert_redirected_to absen_path(assigns(:absen))
  end

  test "should show absen" do
    get :show, id: @absen
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @absen
    assert_response :success
  end

  test "should update absen" do
    patch :update, id: @absen, absen: { alamat: @absen.alamat, nama: @absen.nama, nim: @absen.nim }
    assert_redirected_to absen_path(assigns(:absen))
  end

  test "should destroy absen" do
    assert_difference('Absen.count', -1) do
      delete :destroy, id: @absen
    end

    assert_redirected_to absens_path
  end
end
