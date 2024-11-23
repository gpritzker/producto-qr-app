# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
  class Users::RegistrationsController < Devise::RegistrationsController
    def create
      # Busca si el email ya existe pero no está confirmado
      existing_user = User.find_by(email: sign_up_params[:email])
  
      if existing_user && !existing_user.confirmed?
        # Reenvía las instrucciones de confirmación
        existing_user.send_confirmation_instructions
        flash[:notice] = "Ya existe un registro con este email. Por favor, revisa tu correo para confirmar tu cuenta."
        redirect_to new_user_session_path
      else
        # Comportamiento estándar de Devise
        super
      end
    end
  
    private
  
    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end  
end
