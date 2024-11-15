require "test_helper"

class DelegateCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delegate_company = delegate_companies(:one)
  end

  test "should get index" do
    get delegate_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_delegate_company_url
    assert_response :success
  end

  test "should create delegate_company" do
    assert_difference("DelegateCompany.count") do
      post delegate_companies_url, params: { delegate_company: { accepted: @delegate_company.accepted, email: @delegate_company.email } }
    end

    assert_redirected_to delegate_company_url(DelegateCompany.last)
  end

  test "should show delegate_company" do
    get delegate_company_url(@delegate_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_delegate_company_url(@delegate_company)
    assert_response :success
  end

  test "should update delegate_company" do
    patch delegate_company_url(@delegate_company), params: { delegate_company: { accepted: @delegate_company.accepted, email: @delegate_company.email } }
    assert_redirected_to delegate_company_url(@delegate_company)
  end

  test "should destroy delegate_company" do
    assert_difference("DelegateCompany.count", -1) do
      delete delegate_company_url(@delegate_company)
    end

    assert_redirected_to delegate_companies_url
  end
end
