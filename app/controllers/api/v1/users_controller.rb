module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user_from_token!, only: [
        :sign_out, :refresh_token, :index, :show, :create, :update, :delegations
      ]
      before_action :admin_only!, only: [:create]

      def sign_in
        user = User.find_for_database_authentication(email: sign_in_params[:email])
        
        if user&.valid_password?(sign_in_params[:password])
          jwt = user.generate_jwt
          
          puts "[users:sign_in] token: #{jwt[:auth_token]}"
          render json: {
            message: 'Ingreso exitoso', 
            data: user, 
            token: jwt[:auth_token],
            refresh_token: jwt[:refresh_token],
            exp: jwt[:exp],
            signature_qr: user.generate_signature_qr(jwt[:auth_token])
          }, status: :ok
        else
          render json: {errors: ['Email o contraseña inválidos']}, status: :unauthorized
        end
      end

      def sign_out
        render json: {message: 'Logged out successfully'}, status: :ok and return
      end

      def sign_up
        begin
          existing_user = User.find_by(email: sign_up_params[:email])
      
          if existing_user 
            render json: {errors: ["El usuario ya existe"]}, status: :unprocessable_entity and return
          end
            
          user = User.create(sign_up_params)
          unless user.errors.empty?
            errors = []
            user.errors.each do |error|
              errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
            end              
            render json: { errors: errors }, status: :unprocessable_entity and return
          end
          ConfirmationMailer.with(user: user).confirmation_instructions.deliver_now
          render json: { message: "Por favor, revisa tu correo para confirmar tu cuenta."}, status: :ok
        rescue => e
          render json: {errors: ["Ha ocurrido un error"]}, status: :unprocessable_entity  
        end
      end

      def confirm_mail
        begin
          user = User.find_by(confirmation_token: confirm_mail_params[:confirmation_token])

          if user.present? 
            if user.confirm
              render json: { message: 'Cuenta confirmada con éxito.' }, status: :ok
            else
              render json: { errors: ['Token de confirmación expirado.'] }, status: :forbidden
            end
          else
            render json: { errors: ['Token de confirmación inválido.'] }, status: :unprocessable_entity
          end
        rescue => e
          render json: {errors: ["Ha ocurrido un error"]}, status: :unprocessable_entity 
        end
      end

      def resend_confirmation
        begin
          existing_user = User.find_by(email: resend_confirmation_params[:email])
          unless existing_user.confirmed?
            # Reenvía las instrucciones de confirmación
            ConfirmationMailer.with(user: existing_user).confirmation_instructions.deliver_now
          end
          render json: { message: "Por favor, revisa tu correo para confirmar tu cuenta."}, status: :ok
        rescue => e
          render json: {errors: ["Ha ocurrido un error"]}, status: :unprocessable_entity  
        end
      end

      def refresh_token
        begin
          decoded_token = JWT.decode(
            refresh_token_params[:refresh_token], 
            Rails.application.secret_key_base, 
            true, 
            { algorithm: 'HS256' }
          )
          unless decoded_token[0] == @auth_token
            raise 'Invalid refresh token'
          end
          
          jwt = @current_user.generate_jwt
        
          render json: {
            token: jwt[:auth_token],
            refresh_token: jwt[:refresh_token],
            exp: jwt[:exp],
            signature_qr: @current_user.generate_signature_qr(jwt[:auth_token])
          }, status: :ok
        rescue => e
          puts "[users:refresh_token] #{decoded_token[0]} != #{@auth_token}"
          puts "[users:refresh_token] #{e.message}"
          render json: { errors: [e.message] }, status: :unauthorized
        end
      end

      def index
        if @current_user.admin?
          render json: {data: User.all}, status: :ok
        else
          render json: {data: @current_user}, status: :ok
        end
      end

      def show
        if @current_user.admin?
          render json: {data: User.find(params[:id])}, status: :ok
        else
          render json: {data: @current_user}, status: :ok
        end
      end

      def create
        begin
          user = User.create(user_params.except(:signature_file))
          unless user.errors.empty?
            errors = []
            user.errors.each do |error|
              errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
            end              
            render json: { errors: errors }, status: :unprocessable_entity and return
          end
          
          if user_params[:signature_file].present?
            # Extraer la parte Base64
            encoded_image = user_params[:signature_file].split(',')[1]
            decoded_image = Base64.decode64(encoded_image)
      
            # Crear un archivo temporal para adjuntar
            temp_file = Tempfile.new(['signature', '.png'])
            temp_file.binmode
            temp_file.write(decoded_image)
            temp_file.rewind
      
            # Adjuntar la firma al usuario
            @user.signature_file.attach(io: temp_file, filename: 'signature.png', content_type: 'image/png')
      
            temp_file.close
            temp_file.unlink
          end
          
          ConfirmationMailer.with(user: user).confirmation_instructions.deliver_now
          render json: {message: "Usuario creado exitosamente"}
        rescue => e
          render json: {errors: ["Error al crear el usuario."]}, status: :unprocessable_entity
        end
      end

      def update
        if @current_user.admin?
          @user = User.find(params[:id])
        else
          @user = @current_user
        end
        
        if user_params[:current_password].present? # Cambio de contraseña
          if @user.valid_password?(user_params[:current_password])
            if user_params[:password] == user_params[:password_confirmation]
              if @user.update(password: user_params[:password])
                render json: {message: "Contraseña actualizada exitosamente."}, status: :ok and return
              end
              render json: {errors: ["Hubo un problema al actualizar la contraseña."]}, status: :unprocessable_entity and return
            end
            render json: {errors: ["La nueva contraseña y su confirmación no coinciden."]}, status: :unprocessable_entity and return
          end
          render json: {errors: ["La contraseña actual no es correcta."]}, status: :unprocessable_entity and return
        else # Actualización general del usuario (sin contraseña)
          filtered_params = user_params.except(:password, :password_confirmation, :current_password, :signature_file)
          if user_params[:signature_file].present?
            # Extraer la parte Base64
            encoded_image = user_params[:signature_file].split(',')[1]
            decoded_image = Base64.decode64(encoded_image)
      
            # Crear un archivo temporal para adjuntar
            temp_file = Tempfile.new(['signature', '.png'])
            temp_file.binmode
            temp_file.write(decoded_image)
            temp_file.rewind
      
            # Adjuntar la firma al usuario
            @user.signature_file.attach(io: temp_file, filename: 'signature.png', content_type: 'image/png')
      
            temp_file.close
            temp_file.unlink
          end
          if @user.update(filtered_params)
            render json: {message: "Usuario actualizado exitosamente."}, status: :ok
          else
            render json: {errors: ["Hubo un problema al actualizar el usuario."]}, status: :unprocessable_entity
          end
        end
      end

      def delegations
        render json: {data: Delegation.with_email(@current_user.email)}, status: :ok
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def sign_up_params
        params.require(:user).permit(
          :name, :email, :password, :password_confirmation, :phone,
          :bussiness, :position
        )
      end

      def confirm_mail_params
        params.permit(:confirmation_token)
      end

      def resend_confirmation_params
        params.require(:user).permit(:email)
      end

      def refresh_token_params
        params.permit(:refresh_token)
      end

      def user_params
        params.require(:user).permit(
          :email, :password, :password_confirmation, :current_password, 
          :admin, :name, :bussiness, :position, :phone, :cuil, :signature_file,
          dni_files: []
        )
      end
    end
  end
end