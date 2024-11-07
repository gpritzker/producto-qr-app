require "test_helper"

class ReglamentoTecnicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reglamento_tecnico = reglamento_tecnicos(:one)
  end

  test "should get index" do
    get reglamento_tecnicos_url
    assert_response :success
  end

  test "should get new" do
    get new_reglamento_tecnico_url
    assert_response :success
  end

  test "should create reglamento_tecnico" do
    assert_difference("ReglamentoTecnico.count") do
      post reglamento_tecnicos_url, params: { reglamento_tecnico: { nombre: @reglamento_tecnico.nombre } }
    end

    assert_redirected_to reglamento_tecnico_url(ReglamentoTecnico.last)
  end

  test "should show reglamento_tecnico" do
    get reglamento_tecnico_url(@reglamento_tecnico)
    assert_response :success
  end

  test "should get edit" do
    get edit_reglamento_tecnico_url(@reglamento_tecnico)
    assert_response :success
  end

  test "should update reglamento_tecnico" do
    patch reglamento_tecnico_url(@reglamento_tecnico), params: { reglamento_tecnico: { nombre: @reglamento_tecnico.nombre } }
    assert_redirected_to reglamento_tecnico_url(@reglamento_tecnico)
  end

  test "should destroy reglamento_tecnico" do
    assert_difference("ReglamentoTecnico.count", -1) do
      delete reglamento_tecnico_url(@reglamento_tecnico)
    end

    assert_redirected_to reglamento_tecnicos_url
  end
end
