require "application_system_test_case"

class DelegateCompaniesTest < ApplicationSystemTestCase
  setup do
    @delegate_company = delegate_companies(:one)
  end

  test "visiting the index" do
    visit delegate_companies_url
    assert_selector "h1", text: "Delegate companies"
  end

  test "should create delegate company" do
    visit delegate_companies_url
    click_on "New delegate company"

    check "Accepted" if @delegate_company.accepted
    fill_in "Email", with: @delegate_company.email
    click_on "Create Delegate company"

    assert_text "Delegate company was successfully created"
    click_on "Back"
  end

  test "should update Delegate company" do
    visit delegate_company_url(@delegate_company)
    click_on "Edit this delegate company", match: :first

    check "Accepted" if @delegate_company.accepted
    fill_in "Email", with: @delegate_company.email
    click_on "Update Delegate company"

    assert_text "Delegate company was successfully updated"
    click_on "Back"
  end

  test "should destroy Delegate company" do
    visit delegate_company_url(@delegate_company)
    click_on "Destroy this delegate company", match: :first

    assert_text "Delegate company was successfully destroyed"
  end
end
