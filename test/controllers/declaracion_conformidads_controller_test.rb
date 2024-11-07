require "test_helper"

class DeclaracionConformidadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @declaracion_conformidad = declaracion_conformidads(:one)
  end

  test "should get index" do
    get declaracion_conformidads_url
    assert_response :success
  end

  test "should get new" do
    get new_declaracion_conformidad_url
    assert_response :success
  end

  test "should create declaracion_conformidad" do
    assert_difference("DeclaracionConformidad.count") do
      post declaracion_conformidads_url, params: { declaracion_conformidad: { emisor_reporte: @declaracion_conformidad.emisor_reporte, estado: @declaracion_conformidad.estado, fecha_emision: @declaracion_conformidad.fecha_emision, numero_reporte: @declaracion_conformidad.numero_reporte, producto_id: @declaracion_conformidad.producto_id, reglamento_tecnico_id: @declaracion_conformidad.reglamento_tecnico_id, tipo_procedimiento_id: @declaracion_conformidad.tipo_procedimiento_id } }
    end

    assert_redirected_to declaracion_conformidad_url(DeclaracionConformidad.last)
  end

  test "should show declaracion_conformidad" do
    get declaracion_conformidad_url(@declaracion_conformidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_declaracion_conformidad_url(@declaracion_conformidad)
    assert_response :success
  end

  test "should update declaracion_conformidad" do
    patch declaracion_conformidad_url(@declaracion_conformidad), params: { declaracion_conformidad: { emisor_reporte: @declaracion_conformidad.emisor_reporte, estado: @declaracion_conformidad.estado, fecha_emision: @declaracion_conformidad.fecha_emision, numero_reporte: @declaracion_conformidad.numero_reporte, producto_id: @declaracion_conformidad.producto_id, reglamento_tecnico_id: @declaracion_conformidad.reglamento_tecnico_id, tipo_procedimiento_id: @declaracion_conformidad.tipo_procedimiento_id } }
    assert_redirected_to declaracion_conformidad_url(@declaracion_conformidad)
  end

  test "should destroy declaracion_conformidad" do
    assert_difference("DeclaracionConformidad.count", -1) do
      delete declaracion_conformidad_url(@declaracion_conformidad)
    end

    assert_redirected_to declaracion_conformidads_url
  end
end
