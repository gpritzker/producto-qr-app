module Api
  module V1
    class DjcsController < ApplicationController
      before_action :authenticate_user_from_token!, except: [:download]
      before_action :set_djc, only: [:sign, :approve, :show, :update, :destroy, :download, :certificados]
      before_action :set_role, only: [:sign, :approve]
      before_action do PaperTrail.request.whodunnit = @current_user&.id end

      def sign
        if @role.apoderado? 
          if @djc.update(signed_by: @current_user, signed_at: Time.current)
            @djc.generate_pdf
            render json: {message: "Se firmo exitosamente.", data: @djc}, status: :ok
          else
            unless @djc.errors.empty?
              errors = []
              @djc.errors.each do |error|
                errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
              end              
              render json: { errors: errors }, status: :unprocessable_entity and return
            end
            render json: {errors: ["No se pudo firmar la DJC"]}, status: :unprocessable_entity
          end
        else
          render json: {errors: ["No puede firmar la declaracion jurada de conformidad"]}, status: :forbidden
        end
      end

      def approve
        if @role.apoderado? || @role.supervisor?
          if @djc.update(approved_by: current_user, approved_at: Time.current)
            @djc.generate_pdf
            render json: {message: "Se aprobó exitosamente.", data: @djc}, status: :ok
          else
            unless @djc.errors.empty?
              errors = []
              @djc.errors.each do |error|
                errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
              end              
              render json: { errors: errors }, status: :unprocessable_entity and return
            end
            render json: {errors: ["No se pudo aprobar la DJC"]}, status: :unprocessable_entity
          end
        else
          render json: {errors: ["No puede apeobar la declaracion jurada de conformidad"]}, status: :forbidden
        end
      end

      def create
        begin
          PaperTrail.request.whodunnit = current_user.id if current_user.present?
          @djc = Djc.new(djcs_params)
          @djc.creator = current_user
          unless @djc.save
            unless @djc.errors.empty?
              errors = []
              @djc.errors.each do |error|
                errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
              end              
              render json: { errors: errors }, status: :unprocessable_entity and return
            end
            render json: {errors: ["No se pudo crear la DJC"]}, status: :unprocessable_entity and return
          end
          @djc.generate_pdf
          render json: {message: "DJC creada exitosamente", data: @djc}, status: :ok
        rescue => e
          logger.error e.message
          render json: {errors: ["No se pudo crear la DJC"]}, status: :unprocessable_entity
        end
      end

      def index
        if @current_user.admin?
          @djcs = Djc.all
        else
          @djcs = User.djcs_with_role(@current_user.id)
        end
        render json: {data: @djcs}, status: :ok
      end

      def show
        render json: {data: @djc}, status: :ok
      end

      def download
        if @djc.djc_file.attached? # Descargar el archivo adjunto desde S3
          redirect_to rails_blob_url(@djc.djc_file, disposition: "attachment")
        else # Si no hay archivo adjunto, manejar el error
          logger.warn "Archivo PDF faltante para DJC con ID #{@djc.id} y código #{@djc.qr.code}"
          render json: {errors: ["El documento solicitado no está disponible en este momento."]}, status: :unprocessable_entity
        end
    
        # @djc.generate_pdf
        # send_data @djc.djc_file.download,
        #             filename: @djc.djc_file.filename.to_s,
        #             type: @djc.djc_file.content_type,
        #             disposition: 'inline'
      end

      def update
        if @djc.update(djc_params)
          render json: {message: 'DJC actualizada exitosamente.'}, status: :ok
        else
          unless @djc.errors.empty?
            errors = []
            @djc.errors.each do |error|
              errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
            end              
            render json: { errors: errors }, status: :unprocessable_entity and return
          end
          render json: {errors: ["No se pudo actualizar la DJC"]}, status: :unprocessable_entity
        end
      end

      def certificados
        if @djc.update(djc_params)
          render json: {message: 'Certificados guardados exitosamente.'}, status: :ok
        else
          unless @djc.errors.empty?
            errors = []
            @djc.errors.each do |error|
              errors.push({"attribute" => error.attribute.to_s, "message" => error.options.dig(:message)})
            end              
            render json: { errors: errors }, status: :unprocessable_entity and return
          end
          render json: {errors: ["No se pudo guardar los certificados"]}, status: :unprocessable_entity
        end
      end

      private

      def set_djc
        @djc = Djc.find(params[:id])
        unless @djc
          return render json: {
            errors: ["No se encontró la declaracion jurada de conformidad"]
          }, status: :not_found
        end
      end

      def set_role
        @role = current_user.roles.where(company_id: @djc.company_id).first
        unless @role
          return render json: {
            errors: ["No puede modificar la declaracion jurada de conformidad"]
          }, status: :forbidden
        end
      end

      def djcs_params
        params.require(:djc).permit(
          :company_id,
          :qr_id,
          :tipo_procedimiento_id,
          :reglamento_tecnico_id,
          :product_description,
          :deposit_address,
          :manufacturer,
          :origin,
          :trade_mark,
          :manufacturer_address,
          technical_normatives: [],
          product_attributes: [:brand, :model, :characteristic],
          reports: [:number, :emitter]
        )
      end
    end
  end
end