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

users = [
  {email: "admin@admin.com", name: "ADMINISTRADOR"},
  {email: "pablo.paganini@gmail.com", name: "Pablo"},
  {email: "gjpritzker@gmail.com", name: "Gonzalo"},
  {email: "diego.groll@gmail.com", name: "Diego Groll"},
  {email: "gbergese@gmail.com", name: "Guillermo"},
  {email: "angelimardbp@gmail.com", name: "ANGELIMAR"},
]
users.each do |u|
  admin = User.new
  admin.email = u[:email]
  admin.name = u[:name]
  admin.password = 'Admin123'
  admin.bussiness = "ninguno"
  admin.position = "ninguno"
  admin.phone = "1123452345"
  admin.admin = true

  admin.skip_confirmation!
  admin.save

  admin.update(
    confirmed_at: Time.current # Marca el email como confirmado
  )
end
