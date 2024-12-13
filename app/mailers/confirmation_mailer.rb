class ConfirmationMailer < ApplicationMailer

  def confirmation_instructions
    @user = params[:user]
    @confirmation_url = "#{ENV['APP_HOST']}confirmation?confirmation_token=#{@user.confirmation_token}"
    mail(to: @user.email, subject: 'Confirma tu cuenta')
  end

end
