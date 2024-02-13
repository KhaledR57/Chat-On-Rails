require "test_helper"

class Api::V1::MyApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_my_application = api_v1_my_applications(:one)
  end

  test "should get index" do
    get api_v1_my_applications_url, as: :json
    assert_response :success
  end

  test "should create api_v1_my_application" do
    assert_difference("MyApplication.count") do
      post api_v1_my_applications_url, params: { api_v1_my_application: { chats_count: @api_v1_my_application.chats_count, name: @api_v1_my_application.name, token: @api_v1_my_application.token } }, as: :json
    end

    assert_response :created
  end

  test "should show api_v1_my_application" do
    get api_v1_my_application_url(@api_v1_my_application), as: :json
    assert_response :success
  end

  test "should update api_v1_my_application" do
    patch api_v1_my_application_url(@api_v1_my_application), params: { api_v1_my_application: { chats_count: @api_v1_my_application.chats_count, name: @api_v1_my_application.name, token: @api_v1_my_application.token } }, as: :json
    assert_response :success
  end

  test "should destroy api_v1_my_application" do
    assert_difference("MyApplication.count", -1) do
      delete api_v1_my_application_url(@api_v1_my_application), as: :json
    end

    assert_response :no_content
  end
end
