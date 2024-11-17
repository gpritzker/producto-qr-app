class DelegationsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado

  def index
    @delegations = Delegation.with_email(current_user.email)#.sort(id: :desc)
  end
end
