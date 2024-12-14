class ApplicationController < ActionController::API
  
  private

  def authenticate_user_from_token!
    @auth_token = request.headers['Authorization'].to_s.split(' ').last
    begin
      decoded_token = JWT.decode(@auth_token, Rails.application.secret_key_base, true, { algorithm: 'HS256', leeway: 10 })
      user_id = decoded_token[0]['user_id']
      @current_user = User.find(user_id)
    rescue JWT::ExpiredSignature => e
      render json: { errors: ['Expired token'] }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      # , "token: #{@auth_token}", "secret: #{Rails.application.secret_key_base}"
      render json: { errors: ['Invalid token', e.message] }, status: :unauthorized
    end
  end

  def admin_only!
    unless @current_user.admin?
      render json: { errors: ['Acceso denegado'] }, status: :unauthorized
    end
  end
end
