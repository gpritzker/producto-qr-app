module Api
  module V1
    class CompaniesController < ApplicationController
      
      def index
        if current_user.admin?
          companies = Company.all
        else
          companies = User.companies_with_role(current_user.id)
        end
        render ApiResponseService::ok(data: companies)
      end

      def qrs
        qrs = Qr.where(company_id: params[:id])
        render ApiResponseService::ok(data: qrs)
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
