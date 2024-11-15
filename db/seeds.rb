# db/seeds.rb
admin = User.new
admin.email = "admin@admin.com"
admin.name = "ADMINISTRADOR"
admin.password = '12345678'
admin.bussiness = "ninguno"
admin.position = "ninguno"
admin.phone = "1123452345"
admin.admin = true
admin.save

user = User.new
user.email = "delegado@admin.com"
user.name = "DELEGADO"
user.password = '12345678'
user.bussiness = "ninguno"
user.position = "ninguno"
user.phone = "1123452345"
user.admin = false
user.save


reglamentos_tecnicos = [
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


# db/seeds.rb

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