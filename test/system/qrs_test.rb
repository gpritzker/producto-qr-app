require "application_system_test_case"

class QrsTest < ApplicationSystemTestCase
  setup do
    @qr = qrs(:one)
  end

  test "visiting the index" do
    visit qrs_url
    assert_selector "h1", text: "Qrs"
  end

  test "should create qr" do
    visit qrs_url
    click_on "New qr"

    fill_in "Url destino", with: @qr.url_destino
    fill_in "Estado", with: @qr.estado
    click_on "Create Qr"

    assert_text "Qr was successfully created"
    click_on "Back"
  end

  test "should update Qr" do
    visit qr_url(@qr)
    click_on "Edit this qr", match: :first

    fill_in "Url destino", with: @qr.url_destino
    fill_in "Estado", with: @qr.estado
    click_on "Update Qr"

    assert_text "Qr was successfully updated"
    click_on "Back"
  end

  test "should destroy Qr" do
    visit qr_url(@qr)
    click_on "Destroy this qr", match: :first

    assert_text "Qr was successfully destroyed"
  end
end
