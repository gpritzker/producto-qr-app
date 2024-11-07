require "application_system_test_case"

class EmpresasTest < ApplicationSystemTestCase
  setup do
    @empresa = empresas(:one)
  end

  test "visiting the index" do
    visit empresas_url
    assert_selector "h1", text: "Empresas"
  end

  test "should create empresa" do
    visit empresas_url
    click_on "New empresa"

    fill_in "Cuit", with: @empresa.CUIT
    fill_in "Apoderado cuil", with: @empresa.apoderado_CUIL
    fill_in "Apoderado cargo", with: @empresa.apoderado_cargo
    fill_in "Apoderado contacto", with: @empresa.apoderado_contacto
    fill_in "Apoderado nombre", with: @empresa.apoderado_nombre
    fill_in "Domicilio legal", with: @empresa.domicilio_legal
    fill_in "Estado", with: @empresa.estado
    fill_in "Razon social", with: @empresa.razon_social
    click_on "Create Empresa"

    assert_text "Empresa was successfully created"
    click_on "Back"
  end

  test "should update Empresa" do
    visit empresa_url(@empresa)
    click_on "Edit this empresa", match: :first

    fill_in "Cuit", with: @empresa.CUIT
    fill_in "Apoderado cuil", with: @empresa.apoderado_CUIL
    fill_in "Apoderado cargo", with: @empresa.apoderado_cargo
    fill_in "Apoderado contacto", with: @empresa.apoderado_contacto
    fill_in "Apoderado nombre", with: @empresa.apoderado_nombre
    fill_in "Domicilio legal", with: @empresa.domicilio_legal
    fill_in "Estado", with: @empresa.estado
    fill_in "Razon social", with: @empresa.razon_social
    click_on "Update Empresa"

    assert_text "Empresa was successfully updated"
    click_on "Back"
  end

  test "should destroy Empresa" do
    visit empresa_url(@empresa)
    click_on "Destroy this empresa", match: :first

    assert_text "Empresa was successfully destroyed"
  end
end
