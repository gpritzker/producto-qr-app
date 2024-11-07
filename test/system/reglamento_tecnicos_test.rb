require "application_system_test_case"

class ReglamentoTecnicosTest < ApplicationSystemTestCase
  setup do
    @reglamento_tecnico = reglamento_tecnicos(:one)
  end

  test "visiting the index" do
    visit reglamento_tecnicos_url
    assert_selector "h1", text: "Reglamento tecnicos"
  end

  test "should create reglamento tecnico" do
    visit reglamento_tecnicos_url
    click_on "New reglamento tecnico"

    fill_in "Nombre", with: @reglamento_tecnico.nombre
    click_on "Create Reglamento tecnico"

    assert_text "Reglamento tecnico was successfully created"
    click_on "Back"
  end

  test "should update Reglamento tecnico" do
    visit reglamento_tecnico_url(@reglamento_tecnico)
    click_on "Edit this reglamento tecnico", match: :first

    fill_in "Nombre", with: @reglamento_tecnico.nombre
    click_on "Update Reglamento tecnico"

    assert_text "Reglamento tecnico was successfully updated"
    click_on "Back"
  end

  test "should destroy Reglamento tecnico" do
    visit reglamento_tecnico_url(@reglamento_tecnico)
    click_on "Destroy this reglamento tecnico", match: :first

    assert_text "Reglamento tecnico was successfully destroyed"
  end
end
