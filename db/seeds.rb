# db/seeds.rb
reglamentos_tecnicos = [
  'Seguridad Eléctrica Res. 169/2018',
  'Materiales para la construcción Res. 236/2024',
  'Eficiencia Energética Res. 319/1999',
  "Acero para la construcción",
  "Ascensores y sus componentes de seguridad",
  "Barras y perfiles de aluminio",
  "Bicicletas de uso infantil",
  "Cámaras y cubiertas de bicicletas",
  "Cementos para la construcción",
  "Elementos de protección personal",
  "Encendedores",
  "Juguetes",
  "Papel envasado",
  "Placas y Baldosas Cerámicas",
  "Productos gráficos impresos - Tintas, lacas y barnices",
  "Radiadores de aluminio",
  "Tableros compensados de madera"
]

reglamentos_tecnicos.each do |nombre|
  ReglamentoTecnico.find_or_create_by(nombre: nombre)
end

tipos_procedimiento = [
  "Certificación de Marca emitida en Argentina",
  "Certificación de Tipo emitida en Argentina",
  "Certificación de Lote emitida en Argentina",
  "Certificación emitida fuera de Argentina",
  "Reporte de Ensayos"
]

tipos_procedimiento.each do |nombre|
  TipoProcedimiento.find_or_create_by(nombre: nombre)
end

admin = User.new
admin.email = "admin@admin.com"
admin.name = "ADMINISTRADOR"
admin.password = 'Admin123'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = true
admin.save

admin.reload

admin.update(
  confirmed_at: Time.current # Marca el email como confirmado
)

admin = User.new
admin.email = "pablo.paganini@gmail.com"
admin.name = "Pablo"
admin.password = 'Admin123'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = false
admin.save
admin.update(
  confirmed_at: Time.current # Marca el email como confirmado
)

admin = User.new
admin.email = "gjpritzker@gmail.com"
admin.name = "Gonzalo"
admin.password = 'Milo3009#'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = false
admin.save
admin.update(
  confirmed_at: Time.current # Marca el email como confirmado
)

admin = User.new
admin.email = "diego.groll@gmail.com"
admin.name = "Diego Groll"
admin.password = 'Admin123'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = false
admin.save
admin.update(
  confirmed_at: Time.current # Marca el email como confirmado
)

admin = User.new
admin.email = "gbergese@gmail.com"
admin.name = "Guillermo"
admin.password = 'Admin123'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = false
admin.save
admin.update(
  confirmed_at: Time.current # Marca el email como confirmado
)

admin = User.new
admin.email = "angelimardbp@gmail.com"
admin.name = "ANGELIMAR"
admin.password = 'Admin123'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = false
admin.save
admin.update(
  confirmed_at: Time.current # Marca el email como confirmado
)