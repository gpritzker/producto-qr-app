require "application_system_test_case"

class DelegacionsTest < ApplicationSystemTestCase
  setup do
    @delegacion = delegacions(:one)
  end

  test "visiting the index" do
    visit delegacions_url
    assert_selector "h1", text: "Delegacions"
  end

  test "should create delegacion" do
    visit delegacions_url
    click_on "New delegacion"

    fill_in "Empresa", with: @delegacion.empresa_id
    check "Permisos delegacion" if @delegacion.permisos_delegacion
    fill_in "Usuario destino", with: @delegacion.usuario_destino_id
    fill_in "Usuario origen", with: @delegacion.usuario_origen_id
    click_on "Create Delegacion"

    assert_text "Delegacion was successfully created"
    click_on "Back"
  end

  test "should update Delegacion" do
    visit delegacion_url(@delegacion)
    click_on "Edit this delegacion", match: :first

    fill_in "Empresa", with: @delegacion.empresa_id
    check "Permisos delegacion" if @delegacion.permisos_delegacion
    fill_in "Usuario destino", with: @delegacion.usuario_destino_id
    fill_in "Usuario origen", with: @delegacion.usuario_origen_id
    click_on "Update Delegacion"

    assert_text "Delegacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Delegacion" do
    visit delegacion_url(@delegacion)
    click_on "Destroy this delegacion", match: :first

    assert_text "Delegacion was successfully destroyed"
  end
end
