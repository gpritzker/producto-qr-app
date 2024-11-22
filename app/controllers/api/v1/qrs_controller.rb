module Api
  module V1
    class QrsController < ApplicationController
      
      def create
        begin
          # Primero hay que verificar que pueda crear un QR para esta compañia
          unless current_user.admin?
            unless  User.joins(:roles => :company).
                    where(users: { id: current_user.id }, companies: { id: qr_params[:company_id]}).
                    exists?
              raise "No puede crear QRs para esa compañia"
            end
          end
          # Creo el QR
          qr = Qr.new(qr_params)
          unless qr.save
            messages = qr.errors.map do |err|
              err.options&.[](:message) || "Error message not available"
            end
            return render json: {messages: messages}, status: :unprocessable_entity
          else
            render json: {message: "Qr creado exitosamente", data: qr.reload}, status: :ok
          end
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :forbidden
        end
      end

      private

      def qr_params
        params.require(:qr).permit(:company_id, :description)
      end
    end
  end
end
