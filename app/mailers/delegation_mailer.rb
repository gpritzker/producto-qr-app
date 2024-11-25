class DelegationMailer < ApplicationMailer
    def delegation_email(rol, email, company_name, user_name)
      @company_name = company_name
      @email = email
      @user_name = user_name
      @rol =  rol
      mail(to: email, subject: "Se te ha delegado una nueva empresa")
    end
  end