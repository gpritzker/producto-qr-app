class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only # Solo administradores pueden acceder

  def index
    @users = User.all
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "Usuario actualizado exitosamente."
    else
      render :edit, alert: "Error al actualizar el usuario."
    end
  end

  private

  def admin_only
    redirect_to root_path, alert: "No tienes permisos para acceder a esta sección." unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin)
  end
end
