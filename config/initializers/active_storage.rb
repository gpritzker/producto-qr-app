# # config/initializers/active_storage.rb

# ActiveSupport.on_load(:active_storage_blob) do
#     # Sobrescribir el método `key` para agregar prefijos basados en el nombre del attachment
#     def key
#       return @key if @key.present?
  
#       if respond_to?(:attachment)
#         prefix = case attachment.name.to_s
#                  when 'crs_files'
#                    'crs_files/'
#                 when 'estatuto_file'
#                     'estatutos/'
#                  when 'dni'
#                    'dnis/'
#                  when 'signature'
#                    'signatures/'
#                  when 'authorization'
#                    'authorizations/'
#                  # Añade más casos según tus necesidades
#                  else
#                    ''
#                  end
#       else
#         prefix = ''
#       end
  
#       @key = "#{prefix}#{SecureRandom.uuid}/#{filename}"
#     end
#   end  