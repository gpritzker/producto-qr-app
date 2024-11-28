class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  def set_paper_trail_whodunnit
    super
    Rails.logger.info("PaperTrail whodunnit set to: #{PaperTrail.request.whodunnit}")
  end
  
  before_action do
    Rails.logger.info "Current User: #{current_user.inspect}"
    PaperTrail.request.whodunnit = current_user.present? ? current_user.id : "Sistema"
  end

  protected

  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = current_user&.id
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name, :bussiness, :position, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :name, :bussiness, :position, :phone])
  end
end
