require 'test_helper'

class DepotControllerTest < ActionController::TestCase
  test "should get addDepot" do
    get :addDepot
    assert_response :success
  end

end
