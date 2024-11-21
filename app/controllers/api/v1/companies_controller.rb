module Api
  module V1
    class CompaniesController < ApplicationController
      
      def index
        if current_user.admin?
          companies = Company.all
        else
          companies = User.companies_with_role(current_user.id)
        end
        render json: {data: companies}, status: :ok
      end

      def qrs
        qrs = Qr.where(company_id: params[:id])
        render json: {data: qrs}, status: :ok
      end 

      private

      def company_params
        params.require(:company).permit(
          :name, :cuit, :address, :contact_name, :contact_phone, :contact_email, :estatuto_file,
          delegation: [:email]
        )
      end
    end
  end
end
