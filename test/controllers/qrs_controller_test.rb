require "test_helper"

class QrsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qr = qrs(:one)
  end

  test "should get index" do
    get qrs_url
    assert_response :success
  end

  test "should get new" do
    get new_qr_url
    assert_response :success
  end

  test "should create qr" do
    assert_difference("Qr.count") do
      post qrs_url, params: { qr: { url_destino: @qr.url_destino, estado: @qr.estado } }
    end

    assert_redirected_to qr_url(Qr.last)
  end

  test "should show qr" do
    get qr_url(@qr)
    assert_response :success
  end

  test "should get edit" do
    get edit_qr_url(@qr)
    assert_response :success
  end

  test "should update qr" do
    patch qr_url(@qr), params: { qr: { url_destino: @qr.url_destino, estado: @qr.estado } }
    assert_redirected_to qr_url(@qr)
  end

  test "should destroy qr" do
    assert_difference("Qr.count", -1) do
      delete qr_url(@qr)
    end

    assert_redirected_to qrs_url
  end
end
