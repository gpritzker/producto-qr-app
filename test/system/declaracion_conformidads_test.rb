require "application_system_test_case"

class DeclaracionConformidadsTest < ApplicationSystemTestCase
  setup do
    @declaracion_conformidad = declaracion_conformidads(:one)
  end

  test "visiting the index" do
    visit declaracion_conformidads_url
    assert_selector "h1", text: "Declaracion conformidads"
  end

  test "should create declaracion conformidad" do
    visit declaracion_conformidads_url
    click_on "New declaracion conformidad"

    fill_in "Emisor reporte", with: @declaracion_conformidad.emisor_reporte
    fill_in "Estado", with: @declaracion_conformidad.estado
    fill_in "Fecha emision", with: @declaracion_conformidad.fecha_emision
    fill_in "Numero reporte", with: @declaracion_conformidad.numero_reporte
    fill_in "Producto", with: @declaracion_conformidad.producto_id
    fill_in "Reglamento tecnico", with: @declaracion_conformidad.reglamento_tecnico_id
    fill_in "Tipo procedimiento", with: @declaracion_conformidad.tipo_procedimiento_id
    click_on "Create Declaracion conformidad"

    assert_text "Declaracion conformidad was successfully created"
    click_on "Back"
  end

  test "should update Declaracion conformidad" do
    visit declaracion_conformidad_url(@declaracion_conformidad)
    click_on "Edit this declaracion conformidad", match: :first

    fill_in "Emisor reporte", with: @declaracion_conformidad.emisor_reporte
    fill_in "Estado", with: @declaracion_conformidad.estado
    fill_in "Fecha emision", with: @declaracion_conformidad.fecha_emision
    fill_in "Numero reporte", with: @declaracion_conformidad.numero_reporte
    fill_in "Producto", with: @declaracion_conformidad.producto_id
    fill_in "Reglamento tecnico", with: @declaracion_conformidad.reglamento_tecnico_id
    fill_in "Tipo procedimiento", with: @declaracion_conformidad.tipo_procedimiento_id
    click_on "Update Declaracion conformidad"

    assert_text "Declaracion conformidad was successfully updated"
    click_on "Back"
  end

  test "should destroy Declaracion conformidad" do
    visit declaracion_conformidad_url(@declaracion_conformidad)
    click_on "Destroy this declaracion conformidad", match: :first

    assert_text "Declaracion conformidad was successfully destroyed"
  end
end
