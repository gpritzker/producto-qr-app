module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_user_from_token!
      before_action :set_company, only: [:show, :destroy, :update]
      
      def index
        if @current_user.admin?
          companies = Company.all.order(name: :asc)
        else
          companies = User.companies_with_role(@current_user.id).order(name: :asc)
        end
        render json: {data: companies}, status: :ok
      end

      def show
        begin
          has_role?
          render json: {data: @company}, status: :ok
        rescue => e
          render json: {errors: [e.message]}, status: :unauthorized
        end
      end

      def qrs
        begin
          has_role?
          qrs = Qr.where(company_id: params[:id])
          render json: {data: qrs}, status: :ok
        rescue => e
          render json: {errors: [e.message]}, status: :unauthorized
        end
      end 

      def destroy
        begin
          has_role?
          if @company.qrs.size.positive?
            raise "No se puede borrar una compañia que tiene QRs asociados"
          end
          @company.destroy
          render json: {message: "Compañía borrada exitosamente..."}, status: :ok
        rescue => e
          render json: {errors: [e.message]}, status: :unauthorized
        end
      end

      def create
        begin
          company = Company.new(company_params.except(:id, :estatuto_file))
          company.transaction do
            company.save!
            Role.create(
              user_id: @current_user.id,
              company_id: company.id,
              role: Role::ROL_DELEGADO
            )
            if company_params[:estatuto_file].present?
              company.estatuto_file = company_params[:estatuto_file]
              company.update!
            end
          end
          render json: {message: 'La empresa fué creada exitosamente' }, status: :ok
        rescue => e
          unless company.errors.empty?
            errors = []
            company.errors.each do |error|
              errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
            end              
            render json: { errors: errors }, status: :unprocessable_entity and return
          end
          render json: {errors: [e.message]}, status: :unprocessable_entity
        end 
      end

      def update
        begin
          has_role?
          @company.update(company_params.except(:id))
          unless @company.errors.empty?
            errors = []
            @company.errors.each do |error|
              errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
            end              
            render json: { errors: errors }, status: :unprocessable_entity and return
          end
          render json: {message: 'La empresa fué actualizada.', data: @company}, status: :ok
        rescue => e
          render json: {errors: [e.message]}, status: :unauthorized
        end
      end

      private

      def set_company
        begin
          @company = Company.find params[:id]
        rescue ActiveRecord::RecordNotFound
          render json: {errors: ["La compañia solicitada no existe"]}, status: :not_found
        end
      end

      def has_role?
        unless @current_user.admin?
          unless @current_user.roles.where(company_id: params[:id]).exists?
            raise "No tiene permisos para operar sobre esta compañia"
          end
        end
      end

      def company_params
        params.require(:company).permit(
          :id, :name, :cuit, :address, :contact_name, :contact_phone, :contact_email, :estatuto_file,
          delegation: [:email]
        )
      end
    end
  end
end
