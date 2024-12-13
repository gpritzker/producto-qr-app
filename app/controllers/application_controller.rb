class ApplicationController < ActionController::API
  
  private

  def authenticate_user_from_token!
    @auth_token = request.headers['Authorization'].to_s.split(' ').last
    secret_key = "ePFj4GrQiJdVzyzgdFJiCKWEVWe+UT1mMZGzUM+kqSpZJf2nnecwljT15dTC1EWlJs9iDAHEfPWZlRohm0hruXDtR+Npl9x0Izjj5KqVAhE4sikD/cBmbgex7u8hAg/ruY+xtziRMutdNXOqioXCE2hOe0xTGcvIjL7rUcoSle+Q3ssEu/q9Q05eDnOxC76axpEgBlmDInLtQPVA+f2RBK3DdJ4Pa11Euv9R6wKj5IPl8rsI03K1ITPK6yuwkQZVdQjyfzlbfVmy/w+4nNooDs1KNfcaUqG/OOLg36oyfeIVnQn5IV5OunCFhlrubQEpviuxgBle3hP8FnbtFbqGVj0lfpYtrV+a/3axXnRWZhh7niX5Vx66fdD+cr6+DJ8CL6ENAwtSsD4XEcKcfDEG1fl8Hb95/omYQwbI--wo5CrzwMW95rZ2JD--CajgSL4Jk76CsgI509JiEw=="
    begin
      decoded_token = JWT.decode(@auth_token, secret_key, true, { algorithm: 'HS256', leeway: 10 })
      user_id = decoded_token[0]['user_id']
      @current_user = User.find(user_id)
    rescue JWT::ExpiredSignature => e
      render json: { errors: ['Expired token'] }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: ['Invalid token', e.message, "token: #{@auth_token}"] }, status: :unauthorized
    end
  end

  def admin_only!
    unless @current_user.admin?
      render json: { errors: ['Acceso denegado'] }, status: :unauthorized
    end
  end
end
