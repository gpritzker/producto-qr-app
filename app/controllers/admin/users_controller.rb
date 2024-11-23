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
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Usuario creado exitosamente."
    else
      render :new, alert: "Error al crear el usuario."
    end
  end

  def edit
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  # def update
  #   if current_user.admin?
  #     @user = User.find(params[:id])
  #   else
  #     @user = current_user
  #   end
    
  #   filtered_params = user_params
  #   if filtered_params[:password].blank?
  #     filtered_params = filtered_params.except(:password, :password_confirmation)
  #   end
    
  #   if @user.update(filtered_params)
  #     redirect_to admin_user_url(@user), notice: "Usuario actualizado exitosamente."
  #   else
  #     render :edit, alert: "Error al actualizar el usuario."
  #   end
  # end

  def update
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  
    if params[:current_password].present? # Cambio de contraseña
      if @user.authenticate(params[:current_password]) # Verificar contraseña actual
        if params[:password] == params[:password_confirmation]
          if @user.update(password: params[:password])
            redirect_to admin_user_url(@user), notice: "Contraseña actualizada exitosamente."
          else
            flash.now[:alert] = "Hubo un problema al actualizar la contraseña."
            render :edit
          end
        else
          flash.now[:alert] = "La nueva contraseña y su confirmación no coinciden."
          render :edit
        end
      else
        flash.now[:alert] = "La contraseña actual no es correcta."
        render :edit
      end
    else # Actualización general del usuario (sin contraseña)
      filtered_params = user_params.except(:password, :password_confirmation, :current_password)
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

  # def user_params
  #   params.require(:user).permit(
  #     :email, :password, :password_confirmation, :admin, 
  #     :name, :bussiness, :position, :phone, :cuil, :signature_file,
  #     dni_files: []      
  #   )
  # end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :current_password, 
      :admin, :name, :bussiness, :position, :phone, :cuil, :signature_file,
      dni_files: []
    )
  end
end
