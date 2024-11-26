module Api
  module V1
    class CompaniesController < ApplicationController
      
      def index
        if current_user.admin?
          companies = Company.all.order(name: :asc)
        else
          companies = User.companies_with_role(current_user.id).order(name: :asc)
        end
        render json: {data: companies}, status: :ok
      end

      def show
        begin
          unless current_user.admin?
            unless current_user.roles.where(company_id: params[:id]).exists?
              raise "No tiene permisos para generar DJC sobre está compañia"
            end
          end
          company = Company.find params[:id]
          render json: {data: company}, status: :ok
        rescue => e
          render json: {message: e.message}, status: :forbidden
        end
      end

      def qrs
        qrs = Qr.where(company_id: params[:id])
        render json: {data: qrs}, status: :ok
      end 

      private

      def company_params
        params.require(:company).permit(
          :id, :name, :cuit, :address, :contact_name, :contact_phone, :contact_email, :estatuto_file,
          delegation: [:email]
        )
      end
    end
  end
end
