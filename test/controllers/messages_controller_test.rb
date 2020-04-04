require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get messages_create_url
    assert_response :success
  end

  test "should get list" do
    get messages_list_url
    assert_response :success
  end

  test "should get mark_red" do
    get messages_mark_red_url
    assert_response :success
  end

end
