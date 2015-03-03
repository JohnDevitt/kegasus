require 'test_helper'

class RoutesControllerTest < ActionController::TestCase
  test "should get build_route" do
    get :build_route
    assert_response :success
  end

  test "should get fulfill_order" do
    get :fulfill_order
    assert_response :success
  end

end
