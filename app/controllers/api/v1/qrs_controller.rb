module Api
  module V1
    class QrsController < ApplicationController
      before_action :authenticate_user_from_token!
      before_action :set_qr, only: %i[download]

      before_action do
        PaperTrail.request.whodunnit = @current_user&.id
      end

      def index
        if @current_user.admin?
          @qrs = Qr.all.order(id: :desc)
        else
          @qrs = Qr.joins(company: :roles).where(roles: { user_id: @current_user.id }).order(id: :desc)
        end
        render json: {data: @qrs}, status: :ok
      end

      def download
        begin
          pdf_content = <<~SVGS
            <?xml version="1.0" encoding="UTF-8"?>
            <svg id="Capa_1" data-name="Capa 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90.7 112.3" width="39.155mm" height="47.264mm">
              <defs>
                <style>
                  .cls-1 {
                    fill: #84a3c9;
                  }

                  .cls-2 {
                    fill: red;
                  }

                  .cls-3 {
                    fill: #1f467a;
                  }

                  .cls-4 {
                    fill: #1d1d1b;
                  }
                </style>
              </defs>
              <g id="Capa_1-2" data-name="Capa 1-2">
                <g>
                  <g transform="scale(1.045) translate(0, 0)">
                    <g>
                      <path class="cls-3" d="M30.67,100.93h.46v.12c0,.14-.03.25-.1.34-.08.1-.21.15-.35.15-.13,0-.24-.05-.32-.13-.11-.11-.13-.24-.13-.67s.02-.55.13-.67c.08-.08.19-.13.32-.13.24,0,.4.14.45.37h.32c-.06-.36-.32-.66-.78-.66-.23,0-.41.08-.55.22-.21.21-.22.42-.22.87s0,.66.22.87c.14.14.32.22.55.22s.43-.08.59-.24c.14-.15.19-.32.19-.6v-.33h-.78v.28Z"/>
                      <polygon class="cls-3" points="31.93 101.81 33.29 101.81 33.29 101.52 32.25 101.52 32.25 100.87 33.14 100.87 33.14 100.58 32.25 100.58 32.25 99.96 33.29 99.96 33.29 99.67 31.93 99.67 31.93 101.81"/>
                      <polygon class="cls-3" points="35.02 101.17 34.04 99.67 33.74 99.67 33.74 101.81 34.06 101.81 34.06 100.3 35.05 101.81 35.35 101.81 35.35 99.67 35.02 99.67 35.02 101.17"/>
                      <polygon class="cls-3" points="35.91 101.81 37.27 101.81 37.27 101.52 36.23 101.52 36.23 100.87 37.12 100.87 37.12 100.58 36.23 100.58 36.23 99.96 37.27 99.96 37.27 99.67 35.91 99.67 35.91 101.81"/>
                      <path class="cls-3" d="M39.21,100.29c0-.36-.26-.62-.66-.62h-.83v2.14h.32v-.9h.41l.45.9h.38l-.49-.95c.24-.07.43-.26.43-.57ZM38.04,100.63v-.67h.48c.22,0,.36.13.36.34s-.15.33-.36.33h-.48Z"/>
                      <path class="cls-3" d="M40.22,99.67l-.78,2.14h.35l.15-.43h.84l.15.43h.35l-.78-2.14h-.26ZM40.02,101.1l.33-.95.32.95h-.66Z"/>
                      <path class="cls-3" d="M42.32,99.67h-.75v2.14h.75c.27,0,.46-.08.61-.27.16-.19.16-.46.16-.8s0-.61-.16-.8c-.15-.19-.34-.27-.61-.27ZM42.65,101.37c-.09.11-.21.15-.37.15h-.39v-1.56h.39c.15,0,.28.04.37.15.1.12.11.32.11.63s0,.52-.11.63Z"/>
                      <path class="cls-3" d="M44.26,99.65c-.23,0-.41.08-.55.22-.21.21-.22.42-.22.87s0,.66.22.87c.14.14.32.22.55.22s.42-.08.55-.22c.21-.21.22-.42.22-.87s0-.66-.22-.87c-.14-.14-.32-.22-.55-.22ZM44.58,101.4c-.08.08-.19.14-.32.14s-.24-.05-.32-.14c-.11-.11-.13-.24-.13-.66s.02-.55.13-.67c.08-.08.19-.13.32-.13s.24.05.32.13c.11.11.13.24.13.67s-.02.55-.13.66Z"/>
                      <path class="cls-3" d="M47.04,99.67h-.81v2.14h.32v-.84h.49c.42,0,.69-.27.69-.65s-.27-.65-.69-.65ZM47.02,100.67h-.47v-.72h.47c.23,0,.38.13.38.36s-.15.36-.38.36Z"/>
                      <path class="cls-3" d="M48.81,99.65c-.23,0-.41.08-.55.22-.21.21-.22.42-.22.87s0,.66.22.87c.14.14.32.22.55.22s.42-.08.55-.22c.21-.21.22-.42.22-.87s0-.66-.22-.87c-.14-.14-.32-.22-.55-.22ZM49.13,101.4c-.08.08-.19.14-.32.14s-.24-.05-.32-.14c-.11-.11-.13-.24-.13-.66s.02-.55.13-.67c.08-.08.19-.13.32-.13s.24.05.32.13c.11.11.13.24.13.67s-.02.55-.13.66Z"/>
                      <path class="cls-3" d="M51.55,100.29c0-.36-.26-.62-.66-.62h-.83v2.14h.32v-.9h.41l.45.9h.38l-.49-.95c.24-.07.43-.26.43-.57ZM50.38,100.63v-.67h.48c.22,0,.36.13.36.34s-.15.33-.36.33h-.48Z"/>
                      <path class="cls-3" d="M55.53,100.38c.04.11.06.23.06.35,0,.1-.01.2-.04.3l.48.11c.03-.13.05-.27.05-.41,0-.21-.04-.41-.11-.59l-.43.24Z"/>
                      <path class="cls-3" d="M55.47,100.24l.43-.23c-.21-.41-.59-.72-1.04-.83l-.05.49h0c.29.09.53.3.66.57Z"/>
                      <path class="cls-3" d="M55.23,101.54l.37.33c.17-.16.3-.36.38-.59l-.48-.11c-.06.14-.15.27-.26.38Z"/>
                      <path class="cls-3" d="M55.52,101.94l-.37-.33s0,0,0,0l-.36-.31.09.47c-.13.05-.26.08-.41.08-.61,0-1.11-.5-1.11-1.11s.5-1.11,1.11-1.11c.07,0,.13,0,.2.02l.04-.49c-.08-.01-.16-.02-.24-.02-.88,0-1.6.72-1.6,1.6s.72,1.6,1.6,1.6c.17,0,.34-.03.5-.08l.07.36.76-.44-.27-.24h0Z"/>
                      <path class="cls-3" d="M57.26,99.25l-1.01,2.77h.56l.17-.49h.98l.16.49h.56l-1.01-2.77h-.42ZM57.14,101.07l.35-1.01.34,1.01h-.69Z"/>
                      <path class="cls-3" d="M60.38,100.82c.27-.1.51-.34.51-.73,0-.46-.33-.85-.9-.85h-1.08v2.77h.54v-1.1h.39l.54,1.1h.63l-.62-1.19ZM59.95,100.46h-.51v-.73h.51c.24,0,.39.15.39.37s-.16.37-.39.37Z"/>
                    </g>
                    <g>
                      <path d="M76.34,95.22H14.35c-2.59,0-4.69-2.1-4.69-4.69V14.37c0-2.59,2.1-4.69,4.69-4.69h61.99c2.59,0,4.69,2.1,4.69,4.69v76.16c0,2.59-2.1,4.69-4.69,4.69ZM14.35,10.18c-2.31,0-4.19,1.88-4.19,4.19v76.16c0,2.31,1.88,4.19,4.19,4.19h61.99c2.31,0,4.19-1.88,4.19-4.19V14.37c0-2.31-1.88-4.19-4.19-4.19H14.35Z"/>
                      <g transform="translate(16.6, 15.66) scale(1.745)">
                        #{@qr.generate_svg}
                      </g>
                      <g>
                        <polygon class="cls-1" points="69.59 76.56 68.37 75.29 59.83 83.83 56.55 80.47 55.42 81.56 59.88 86.23 69.59 76.56"/>
                        <polygon class="cls-1" points="59.83 88.16 56.55 84.8 55.42 85.89 59.88 90.56 69.59 80.89 68.37 79.63 59.83 88.16"/>
                      </g>
                      <g>
                        <path class="cls-4" d="M27.49,76.56l-6.18,14h2.46l1.34-3.16h7.06l1.34,3.16h2.52l-6.12-14h-2.42ZM25.99,85.3l2.64-6.22,2.64,6.22h-5.28Z"/>
                        <path class="cls-4" d="M46.32,85.88c1.86-.72,2.9-2.3,2.9-4.54,0-3.04-2.06-4.78-5.64-4.78h-5.68v14h2.36v-4.22h3.32c.22,0,.44,0,.64-.02l2.56,4.24h2.68l-3.14-4.68ZM43.57,84.22h-3.32v-5.54h3.32c2.16,0,3.4.88,3.4,2.72s-1.24,2.82-3.4,2.82Z"/>
                      </g>
                    </g>
                  </g>
                  <g>
                    <polygon points="6.96 6.98 0 6.98 0 6.73 6.71 6.73 6.71 .02 6.96 .02 6.96 6.98"/>
                    <polygon points="87.73 6.96 95.7 6.96 95.7 6.71 87.98 6.71 87.98 0 87.73 0 87.73 6.96"/>
                  </g>
                  <g>
                    <polygon points="6.96 105.32 0 105.32 0 105.57 6.71 105.57 6.71 112.28 6.96 112.28 6.96 105.32"/>
                    <polygon points="87.73 105.34 95.7 105.34 95.7 105.59 87.98 105.59 87.98 112.3 87.73 112.3 87.73 105.34"/>
                  </g>
                </g>
              </g>
            </svg>
            <br/><br/>
            <svg id="Capa_2" data-name="Capa 2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 44.2 59.59" width="19.728mm" height="26.232mm">
              <defs>
                <style>
                  .cls-1 {
                    fill: #84a3c9;
                  }

                  .cls-2 {
                    fill: red;
                  }

                  .cls-3 {
                    fill: #1f467a;
                  }

                  .cls-4 {
                    fill: #1d1d1b;
                  }
                </style>
              </defs>
              <g id="Capa_2-2" data-name="Capa 1">
                <g>
                  <g>
                    <path d="M36.05,49.18H8.37c-1.03,0-1.88-.84-1.88-1.88V8.29c0-1.03.84-1.88,1.88-1.88h27.68c1.03,0,1.88.84,1.88,1.88v39.02c0,1.03-.84,1.88-1.88,1.88ZM8.37,6.67c-.9,0-1.63.73-1.63,1.63v39.02c0,.9.73,1.63,1.63,1.63h27.68c.9,0,1.63-.73,1.63-1.63V8.29c0-.9-.73-1.63-1.63-1.63H8.37Z"/>
                    <g transform="translate(10.87, 10.79) scale(0.688)">
                      #{@qr.generate_svg}
                    </g>
                    <g>
                      <g>
                        <polygon class="cls-1" points="27.1 40.04 28.54 41.53 32.3 37.77 32.83 38.32 28.56 42.58 26.6 40.53 27.1 40.04"/>
                        <polygon class="cls-1" points="27.1 41.95 28.54 43.43 32.3 39.67 32.83 40.23 28.56 44.49 26.6 42.43 27.1 41.95"/>
                      </g>
                      <g>
                        <path class="cls-4" d="M16.37,43.1h-3.11l-.59,1.39h-1.08l2.72-6.16h1.07l2.69,6.16h-1.11l-.59-1.39ZM15.97,42.17l-1.16-2.74-1.16,2.74h2.32Z"/>
                        <path class="cls-4" d="M22.79,44.49l-1.13-1.87c-.09,0-.18,0-.28,0h-1.46v1.86h-1.04v-6.16h2.5c1.58,0,2.48.77,2.48,2.1,0,.99-.46,1.68-1.28,2l1.38,2.06h-1.18ZM21.38,41.7c.95,0,1.5-.4,1.5-1.24s-.55-1.2-1.5-1.2h-1.46v2.44h1.46Z"/>
                      </g>
                    </g>
                    <g>
                      <path class="cls-3" d="M13.45,52.09h.27v.07c0,.08-.02.15-.06.2-.05.06-.12.09-.21.09-.08,0-.14-.03-.19-.08-.06-.07-.07-.14-.07-.4s.01-.33.07-.4c.05-.05.11-.08.19-.08.14,0,.24.08.27.22h.19c-.03-.22-.19-.39-.46-.39-.14,0-.25.05-.33.13-.12.12-.13.25-.13.52s0,.39.13.52c.08.08.19.13.33.13s.26-.04.35-.14c.08-.09.11-.19.11-.36v-.19h-.46v.16Z"/>
                      <polygon class="cls-3" points="14.2 52.61 15.01 52.61 15.01 52.44 14.39 52.44 14.39 52.06 14.92 52.06 14.92 51.89 14.39 51.89 14.39 51.52 15.01 51.52 15.01 51.34 14.2 51.34 14.2 52.61"/>
                      <polygon class="cls-3" points="16.03 52.24 15.45 51.34 15.27 51.34 15.27 52.61 15.46 52.61 15.46 51.72 16.05 52.61 16.22 52.61 16.22 51.34 16.03 51.34 16.03 52.24"/>
                      <polygon class="cls-3" points="16.56 52.61 17.37 52.61 17.37 52.44 16.75 52.44 16.75 52.06 17.28 52.06 17.28 51.89 16.75 51.89 16.75 51.52 17.37 51.52 17.37 51.34 16.56 51.34 16.56 52.61"/>
                      <path class="cls-3" d="M18.51,51.72c0-.22-.15-.37-.39-.37h-.49v1.27h.19v-.53h.24l.27.53h.22l-.29-.56c.14-.04.25-.16.25-.34ZM17.82,51.92v-.4h.29c.13,0,.22.07.22.2s-.09.2-.22.2h-.29Z"/>
                      <path class="cls-3" d="M19.11,51.34l-.47,1.27h.2l.09-.25h.5l.09.25h.2l-.46-1.27h-.16ZM18.99,52.19l.2-.56.19.56h-.39Z"/>
                      <path class="cls-3" d="M20.35,51.34h-.45v1.27h.45c.16,0,.27-.05.36-.16.09-.11.1-.27.1-.47s0-.36-.1-.47c-.09-.11-.2-.16-.36-.16ZM20.55,52.36c-.05.06-.13.09-.22.09h-.23v-.93h.23c.09,0,.16.02.22.09.06.07.07.19.07.38s0,.31-.07.38Z"/>
                      <path class="cls-3" d="M21.5,51.33c-.14,0-.25.05-.33.13-.12.12-.13.25-.13.52s0,.39.13.52c.08.08.19.13.33.13s.25-.05.33-.13c.12-.12.13-.25.13-.52s0-.39-.13-.52c-.08-.08-.19-.13-.33-.13ZM21.69,52.37s-.11.08-.19.08-.14-.03-.19-.08c-.06-.07-.07-.14-.07-.39s.01-.33.07-.4c.05-.05.11-.08.19-.08s.14.03.19.08c.06.07.07.14.07.4s-.01.33-.07.39Z"/>
                      <path class="cls-3" d="M23.15,51.34h-.48v1.27h.19v-.5h.29c.25,0,.41-.16.41-.38s-.16-.38-.41-.38ZM23.14,51.94h-.28v-.42h.28c.14,0,.22.08.22.21s-.09.21-.22.21Z"/>
                      <path class="cls-3" d="M24.2,51.33c-.14,0-.25.05-.33.13-.12.12-.13.25-.13.52s0,.39.13.52c.08.08.19.13.33.13s.25-.05.33-.13c.12-.12.13-.25.13-.52s0-.39-.13-.52c-.08-.08-.19-.13-.33-.13ZM24.39,52.37s-.11.08-.19.08-.14-.03-.19-.08c-.06-.07-.07-.14-.07-.39s.01-.33.07-.4c.05-.05.11-.08.19-.08s.14.03.19.08c.06.07.07.14.07.4s-.01.33-.07.39Z"/>
                      <path class="cls-3" d="M25.83,51.72c0-.22-.15-.37-.39-.37h-.49v1.27h.19v-.53h.24l.27.53h.22l-.29-.56c.14-.04.25-.16.25-.34ZM25.14,51.92v-.4h.29c.13,0,.22.07.22.2s-.09.2-.22.2h-.29Z"/>
                      <path class="cls-3" d="M28.19,51.77c.02.07.03.14.03.21,0,.06,0,.12-.02.18l.28.06c.02-.08.03-.16.03-.24,0-.12-.02-.24-.07-.35l-.26.14Z"/>
                      <path class="cls-3" d="M28.15,51.68l.26-.14c-.12-.24-.35-.43-.62-.49l-.03.29h0c.17.05.31.18.39.34Z"/>
                      <path class="cls-3" d="M28.01,52.46l.22.19c.1-.1.17-.22.22-.35l-.28-.07c-.04.08-.09.16-.16.22Z"/>
                      <path class="cls-3" d="M28.18,52.69l-.22-.19s0,0,0,0l-.22-.19.05.28c-.07.03-.16.05-.24.05-.36,0-.66-.3-.66-.66s.3-.66.66-.66c.04,0,.08,0,.12.01l.03-.29s-.1-.01-.14-.01c-.52,0-.95.43-.95.95s.43.95.95.95c.1,0,.2-.02.3-.05l.04.21.45-.26-.16-.14h0Z"/>
                      <path class="cls-3" d="M29.22,51.1l-.6,1.64h.33l.1-.29h.58l.1.29h.33l-.6-1.64h-.25ZM29.14,52.18l.21-.6.2.6h-.41Z"/>
                      <path class="cls-3" d="M31.06,52.03c.16-.06.3-.2.3-.43,0-.27-.2-.5-.53-.5h-.64v1.64h.32v-.65h.23l.32.65h.37l-.37-.71ZM30.81,51.81h-.3v-.43h.3c.14,0,.23.09.23.22s-.09.22-.23.22Z"/>
                    </g>
                  </g>
                  <polygon points="5.18 5.18 0 5.18 0 4.99 4.99 4.99 4.99 0 5.18 0 5.18 5.18"/>
                  <polygon points="39.21 5.18 44.2 5.18 44.2 5 39.39 5 39.39 .19 39.21 .19 39.21 5.18"/>
                  <polygon points="5.18 54.42 0 54.42 0 54.6 4.99 54.6 4.99 59.59 5.18 59.59 5.18 54.42"/>
                  <polygon points="39.21 54.41 44.2 54.41 44.2 54.59 39.39 54.59 39.39 59.41 39.21 59.41 39.21 54.41"/>
                </g>
              </g>
            </svg>
          SVGS

          pdf = WickedPdf.new.pdf_from_string(
            pdf_content,
            page_height: '62mm',          # Altura personalizada
            page_width: '58mm',           # Ancho personalizado
            margin: { top: 10, bottom: 0, left: 10, right: 0 },
          )
          # Enviar el PDF como archivo descargable
          send_data pdf,
                    filename: "#{@qr.description.gsub(" ","_")}.pdf", # Nombre del archivo
                    type: "application/pdf",
                    disposition: "attachment" # Forzar descarga attachment
        rescue => e
          Rails.logger.error "Error generating PDF: #{e.message}"
          render json: { errors: ["Error generating PDF: #{e.message}"] }, status: :internal_server_error
        end
      end

      private

      def set_qr
        @qr = Qr.find(params[:id])
      end

      def qr_params
        params.require(:qr).permit(:company_id, :description)
      end
    end
  end
end