require "test_helper"

class EmpresasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @empresa = empresas(:one)
  end

  test "should get index" do
    get empresas_url
    assert_response :success
  end

  test "should get new" do
    get new_empresa_url
    assert_response :success
  end

  test "should create empresa" do
    assert_difference("Empresa.count") do
      post empresas_url, params: { empresa: { CUIT: @empresa.CUIT, apoderado_CUIL: @empresa.apoderado_CUIL, apoderado_cargo: @empresa.apoderado_cargo, apoderado_contacto: @empresa.apoderado_contacto, apoderado_nombre: @empresa.apoderado_nombre, domicilio_legal: @empresa.domicilio_legal, estado: @empresa.estado, razon_social: @empresa.razon_social } }
    end

    assert_redirected_to empresa_url(Empresa.last)
  end

  test "should show empresa" do
    get empresa_url(@empresa)
    assert_response :success
  end

  test "should get edit" do
    get edit_empresa_url(@empresa)
    assert_response :success
  end

  test "should update empresa" do
    patch empresa_url(@empresa), params: { empresa: { CUIT: @empresa.CUIT, apoderado_CUIL: @empresa.apoderado_CUIL, apoderado_cargo: @empresa.apoderado_cargo, apoderado_contacto: @empresa.apoderado_contacto, apoderado_nombre: @empresa.apoderado_nombre, domicilio_legal: @empresa.domicilio_legal, estado: @empresa.estado, razon_social: @empresa.razon_social } }
    assert_redirected_to empresa_url(@empresa)
  end

  test "should destroy empresa" do
    assert_difference("Empresa.count", -1) do
      delete empresa_url(@empresa)
    end

    assert_redirected_to empresas_url
  end
end
