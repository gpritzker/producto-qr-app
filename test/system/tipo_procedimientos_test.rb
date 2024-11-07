require "application_system_test_case"

class TipoProcedimientosTest < ApplicationSystemTestCase
  setup do
    @tipo_procedimiento = tipo_procedimientos(:one)
  end

  test "visiting the index" do
    visit tipo_procedimientos_url
    assert_selector "h1", text: "Tipo procedimientos"
  end

  test "should create tipo procedimiento" do
    visit tipo_procedimientos_url
    click_on "New tipo procedimiento"

    fill_in "Nombre", with: @tipo_procedimiento.nombre
    click_on "Create Tipo procedimiento"

    assert_text "Tipo procedimiento was successfully created"
    click_on "Back"
  end

  test "should update Tipo procedimiento" do
    visit tipo_procedimiento_url(@tipo_procedimiento)
    click_on "Edit this tipo procedimiento", match: :first

    fill_in "Nombre", with: @tipo_procedimiento.nombre
    click_on "Update Tipo procedimiento"

    assert_text "Tipo procedimiento was successfully updated"
    click_on "Back"
  end

  test "should destroy Tipo procedimiento" do
    visit tipo_procedimiento_url(@tipo_procedimiento)
    click_on "Destroy this tipo procedimiento", match: :first

    assert_text "Tipo procedimiento was successfully destroyed"
  end
end
