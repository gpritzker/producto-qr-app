module Api
  module V1
    class ApplicationController < ActionController::Base
      before_action :authenticate_user!  # Asegura que el usuario esté autenticado
    end
  end
end