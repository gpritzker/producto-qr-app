require "test_helper"

class TipoProcedimientosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_procedimiento = tipo_procedimientos(:one)
  end

  test "should get index" do
    get tipo_procedimientos_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_procedimiento_url
    assert_response :success
  end

  test "should create tipo_procedimiento" do
    assert_difference("TipoProcedimiento.count") do
      post tipo_procedimientos_url, params: { tipo_procedimiento: { nombre: @tipo_procedimiento.nombre } }
    end

    assert_redirected_to tipo_procedimiento_url(TipoProcedimiento.last)
  end

  test "should show tipo_procedimiento" do
    get tipo_procedimiento_url(@tipo_procedimiento)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_procedimiento_url(@tipo_procedimiento)
    assert_response :success
  end

  test "should update tipo_procedimiento" do
    patch tipo_procedimiento_url(@tipo_procedimiento), params: { tipo_procedimiento: { nombre: @tipo_procedimiento.nombre } }
    assert_redirected_to tipo_procedimiento_url(@tipo_procedimiento)
  end

  test "should destroy tipo_procedimiento" do
    assert_difference("TipoProcedimiento.count", -1) do
      delete tipo_procedimiento_url(@tipo_procedimiento)
    end

    assert_redirected_to tipo_procedimientos_url
  end
end
