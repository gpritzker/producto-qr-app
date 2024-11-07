require "test_helper"

class DelegacionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delegacion = delegacions(:one)
  end

  test "should get index" do
    get delegacions_url
    assert_response :success
  end

  test "should get new" do
    get new_delegacion_url
    assert_response :success
  end

  test "should create delegacion" do
    assert_difference("Delegacion.count") do
      post delegacions_url, params: { delegacion: { empresa_id: @delegacion.empresa_id, permisos_delegacion: @delegacion.permisos_delegacion, usuario_destino_id: @delegacion.usuario_destino_id, usuario_origen_id: @delegacion.usuario_origen_id } }
    end

    assert_redirected_to delegacion_url(Delegacion.last)
  end

  test "should show delegacion" do
    get delegacion_url(@delegacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_delegacion_url(@delegacion)
    assert_response :success
  end

  test "should update delegacion" do
    patch delegacion_url(@delegacion), params: { delegacion: { empresa_id: @delegacion.empresa_id, permisos_delegacion: @delegacion.permisos_delegacion, usuario_destino_id: @delegacion.usuario_destino_id, usuario_origen_id: @delegacion.usuario_origen_id } }
    assert_redirected_to delegacion_url(@delegacion)
  end

  test "should destroy delegacion" do
    assert_difference("Delegacion.count", -1) do
      delete delegacion_url(@delegacion)
    end

    assert_redirected_to delegacions_url
  end
end
