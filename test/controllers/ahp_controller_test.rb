require 'test_helper'

class AhpControllerTest < ActionController::TestCase
  test "should get criteria" do
    get :criteria
    assert_response :success
  end

end
