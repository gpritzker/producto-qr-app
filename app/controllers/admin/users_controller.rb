class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, only: [:new, :create] # Solo administradores pueden acceder

  def index
    if current_user.admin?
      @users = User.all
    else
      @users = [current_user]
    end
  end

  def show
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.except(:signature_file))
    if @user.save
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
      redirect_to admin_users_path, notice: "Usuario creado exitosamente."
    else
      render :new, alert: "Error al crear el usuario."
    end
  end

  def password
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def edit
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def update
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    if user_params[:current_password].present? # Cambio de contraseña
      if @user.valid_password?(user_params[:current_password])
        if user_params[:password] == user_params[:password_confirmation]
          if @user.update(password: user_params[:password])
            redirect_to admin_user_url(@user), notice: "Contraseña actualizada exitosamente."
          else
            flash.now[:alert] = "Hubo un problema al actualizar la contraseña."
            render :password
          end
        else
          flash.now[:alert] = "La nueva contraseña y su confirmación no coinciden."
          render :password
        end
      else
        flash.now[:alert] = "La contraseña actual no es correcta."
        render :password
      end
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
        redirect_to admin_user_url(@user), notice: "Usuario actualizado exitosamente."
      else
        flash.now[:alert] = "Hubo un problema al actualizar el usuario."
        render :edit
      end
    end
  end

  private

  def admin_only
    redirect_to root_path, alert: "No tienes permisos para acceder a esta sección." unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :current_password, 
      :admin, :name, :bussiness, :position, :phone, :cuil, :signature_file,
      dni_files: []
    )
  end
end
