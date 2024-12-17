[33me5a770f[m[33m ([m[1;36mHEAD -> [m[1;32mstaging[m[33m, [m[1;31morigin/staging[m[33m)[m fix: cambio logger por puts
[33md26471f[m fix: redireccion de stdout
[33m80e1619[m feat: add log
[33md6cfa43[m feat: agregado de signature qr en sign_in y refresh_token
[33m19c9601[m fix: create en api companies
[33mdd7a064[m feat: djc api
[33m1da2b13[m fix: autenticacion
[33m6a72dbd[m fix: mas datos de analisis
[33m411a442[m fix: datos para chequear errores
[33ma79f611[m fix: secret key
[33mf9d1c09[m fix: mas datos de error
[33m6042f3f[m fix: host en config
[33m8b9cb8a[m feat: api delegations & qrs
[33m418150d[m nuevo staging solo api
[33m1dd671c[m[33m ([m[1;31morigin/main[m[33m, [m[1;31morigin/HEAD[m[33m, [m[1;32mmain[m[33m)[m Merge branch 'pdf_djc'
[33ma21f4ab[m[33m ([m[1;31morigin/staging_13122024[m[33m)[m feat: generador de qr para firma de usuario
[33m3429f6a[m feat: agregado de watermark
[33mc1a0903[m feat: pdf para djc
[33m8a2e7f2[m agrego api como host
[33md0a72b9[m remove gem wkhtmltopdf
[33m9abfc29[m remove gem sassc-rail
[33meb3d40d[m fix: agregado de excel de ejemplo
[33m86ed5bd[m feat: carga de caracteristicas tecnicas mediante excel
[33m49fbafc[m restore: gem wicked_pdf
[33m53a5b6a[m fix: add url to libssl1.1
[33m5e5dc0f[m fix: modificacion en initializer wicked_pdf
[33me2d5645[m fix: agregado de librerias
[33m88d7206[m cambio gemas pdf
[33m5c35f08[m Forzando nuevo despliegue en Heroku después de limpiar caché
[33me3a488a[m fixeo vendor/bundle
[33m1291a55[m fix auditorias djc
[33mfc7db66[m fix auditoria
[33m230ae11[m fix: tamaño de hoja y margenes para qr
[33m207f117[m ordeno los index de las auditorias
[33mb0527a3[m fix: qrs print size, djc generate pdf on sign and approve & add origin to djc:new
[33mcc43efa[m fix papaertrail auditoria
[33m7c1c885[m fix papertrail
[33mb3208df[m saco debugger
[33me773209[m fix papertrail
[33m78911de[m Merge pull request #23 from gpritzker/papertraildjc
[33m434095a[m[33m ([m[1;31morigin/papertraildjc[m[33m)[m cambios en auditorias de djc
[33m615f769[m Merge pull request #22 from gpritzker/papertraildjc
[33mf8846a2[m agrego papertrail para djc
[33ma96bf0d[m agrego auditoria a djc
[33m59ee8e9[m feat: qrs con corte y djc en s3
[33md3fcdf1[m cambios en el mail de confirmacion
[33mdc29a9c[m Merge pull request #21 from gpritzker/papertrail
[33m91ad96c[m[33m ([m[1;31morigin/papertrail[m[33m)[m agrego auditoria de qrs
[33m12a740a[m feat: qrs en pdf svg
[33mf224c5f[m feat: creacion y borrado de reglamentos tecnicos y tipos de procedimientos
[33m7132e5b[m agrego S3 para guardar archivos
[33m9402f75[m agrego control de files en el show de djcs
[33meabfd9a[m feat: creacion de firma digital desde la vista
[33m6617de6[m feat: una vez creada la DJC lleva a la carga de certificados
[33m1d4f215[m feat: agregado de delegado sin autorizar
[33m391b093[m feat: borrado de compañias sin QRs
[33m729634d[m fix: correcciones varias
[33m62b23af[m fix: quitado de boton eliminar del listado de usuario & remoción de .env
[33m83cd495[m fix: cambios varios
[33mdd4c227[m mejor inicio de sesion
[33m03c328d[m modifico lavista de recupero de contraseña
[33m65dba15[m mejoro vistas de mails
[33m17ede99[m agrego envio de mails en las delegaciones
[33m49b9794[m cambio host a qar
[33mb7210a9[m cambio host a qar
[33mbf80a1e[m cambio host
[33m45aa8e9[m fix: tamaños de labels
[33m82893a9[m feat: agregado del QR en los labels
[33maf6cb1c[m cambio hosta qar.com.ar
[33md468562[m cambio host ahsta que esten habilitados de el APP_HOST_HEROKU hasta que este bien qar
[33mdaf6fdf[m cambio host ahsta que esten habilitados
[33m24f75b1[m cambio host ahsta que esten habilitados
[33m13891e3[m agrego host qar
[33m92d85f0[m fix: ultimos detalles post pruebas
[33me420f69[m[33m ([m[1;31morigin/alta_qr[m[33m)[m fix: seeders
[33m6ede594[m fix: remocion de columnas y agregado de origen a djc
[33m090d431[m feat: mejora de vista de creación de DJC
[33mad43c63[m feat: mejora en las vistas y uso de js
[33m8ed1645[m feat: mejora en bloque de error
[33m2495a4d[m fix: reordenamiento de errores
[33me8a7053[m feat: agregado de confirmacion al rechazar delegacion
[33md1085b0[m feat: formateo de cuit/cuil
[33m3568aa8[m feat: quitar DNI del usuario
[33m912a14e[m fix: djc:new alias de qr
[33m86678b0[m feat: creacion de QR desde vista de Company
[33m34f1145[m feat: agregado de redireccion a create:djc con company_id
[33ma5d007f[m feat: quitado de edicion de QR & agregado de campo empresa
[33m78cd625[m feat: descarga de qrs
[33m22a7d1e[m feat: quitado de create & new (QR) - agregado de create (Api::V1::QR) - creacion de QR desde vista index
[33me0afc3b[m Merge pull request #20 from gpritzker/fixesvarios
[33m3282921[m[33m ([m[1;31morigin/fixesvarios[m[33m)[m fix flash mensajes
[33m070e410[m Merge pull request #19 from gpritzker/fixesvarios
[33m1c19654[m agrego detalles a la edicion de usuarios
[33m31beac1[m cambio formulario de edit de mis datos
[33me2ba290[m Merge pull request #18 from gpritzker/fixesvarios
[33m291a6b6[m cambio formulario de edit de mis datos
[33m4df6a2d[m Merge pull request #17 from gpritzker/fixesvarios
[33m732da48[m agrego host
[33m7a20125[m Merge pull request #16 from gpritzker/fixesvarios
[33m6aa1e02[m agrego host
[33m5db247f[m Merge pull request #15 from gpritzker/fixesvarios
[33maaa0520[m agrego host
[33m364c040[m Merge pull request #14 from gpritzker/fixesvarios
[33m162f013[m agrego host
[33mc8f0c6e[m Merge pull request #13 from gpritzker/fixesvarios
[33mfc7456e[m fix mensajes de error
[33mfa5074c[m Merge pull request #12 from gpritzker/fixesvarios
[33m5d847ae[m areglo mensajes plash
[33me42ba1f[m Merge pull request #11 from gpritzker/mailconfirmalbe
[33md532622[m[33m ([m[1;31morigin/mailconfirmalbe[m[33m)[m mail de confirmacion al registrarse
[33mca021b3[m agrego mail de qarapp
[33mb836424[m html
[33m212f6d8[m Deja de rastrear .env y actualiza .gitignore
[33m39a5925[m Merge pull request #10 from gpritzker/fixdevelopmentenviroment
[33mcd32a8c[m[33m ([m[1;31morigin/fixdevelopmentenviroment[m[33m)[m Elimina .env del repositorio y lo añade al .gitignore
[33m0bdc956[m fix html y gitignore
[33m6329440[m Merge pull request #9 from gpritzker/fixdevelopmentenviroment
[33m5e080bb[m arreglo vista edit password
[33mca4961b[m Merge pull request #8 from gpritzker/fixdevelopmentenviroment
[33m2e252c3[m fix envio mails
[33m6d022a9[m fix envio mails
[33mbc4ee27[m Merge pull request #7 from gpritzker/fixdevelopmentenviroment
[33m3fcaae7[m saco variables expuestas
[33m6c6a6ad[m fix entorno deje la variables expuestas
[33m5f20a5e[m Merge pull request #6 from gpritzker/fixmailer
[33m75e17d2[m[33m ([m[1;31morigin/fixmailer[m[33m)[m saco variables de .env de mailgun
[33m0351374[m Merge pull request #5 from gpritzker/mailer
[33m3b1e236[m agrego configuracion de mailers
[33m83f6a0a[m Merge pull request #4 from gpritzker/seguridadpass
[33meca947d[m[33m ([m[1;31morigin/seguridadpass[m[33m)[m fix password
[33m7f96180[m fix: remove migrate 20241121153831_add_creator_to_djcs.rb
[33m18444a2[m fix: colspan en vista djcs:index
[33me9c7dc6[m fix: detail de qr pedia autenticacion
[33mfaa0103[m fix: djcs como admin
[33m7967033[m add Procfile
[33m475766d[m fix: roles_controller
[33m6fd6148[m Gemfile & enviroment
[33mc53833b[m cambios gemfile y enviroment production
[33m80cf876[m rem gem rails_12factor
[33me43eb22[m add gem rails_12factor
[33mfb72cfd[m precompile assets
[33m91af4bd[m Add Ruby version to Gemfile
[33m178a19b[m replace uglyfier por terser
[33mf216113[m config.assets.enabled = true
[33mbb0a1f5[m Rakefile sin quitar assets:precompile
[33medc51bf[m add Gemfile.lock
[33m64a1c14[m clean javascript gems
[33m5dc6372[m add jqeury-rails gem
[33m3238fe8[m remove gems
[33md718414[m clean up
[33m757ee4f[m remove signature.js
[33m41a68d2[m Gemfile.lock
[33ma03b055[m Aptfile
[33mec823ed[m feat: agregado de watermark
[33md533eb5[m feat: agregado de CRs en DJC
[33m12ccc36[m feat: mejoras en la muestra de detalle de QR y creacion de DJC
[33m05b478a[m feat: djcs completada
[33m0032012[m Optimización de tamaño del node modules
[33me1984cb[m Optimización de tamaño del slug
[33mb8baf5e[m Precompilación local de activos
[33mf57a05c[m slug ignore
[33m99dd8a6[m Precompilación local de activos
[33m5b694fa[m gitignore
[33mf344abb[m gitignore
[33m44f66ca[m feat: variables de entorno apuntando a heroku
[33mc1f2412[m feat: agregar creator a djc
[33m5c3aeaf[m fix: create company
[33mf09edd8[m feat: creacion de pdf de djc
[33md73452a[m feat: qr & djc
[33mfcf41d6[m saco link a declaraciones de conformidad
[33m99e83d2[m Merge pull request #3 from gpritzker/tags-google
[33m0b6553a[m[33m ([m[1;31morigin/tags-google[m[33m)[m agrego tag manager
[33m332a4ec[m Merge pull request #2 from gpritzker/new_master
[33ma644c3f[m fix: company validates
[33mde31019[m Merge pull request #1 from gpritzker/new_master
[33m7af17a5[m change: seed
[33m7d0de65[m feat: add es languague for devise
[33m3ff55f7[m feat: agregado de mensaje de validaciones
[33me216940[m fix: vista de compañia como admin
[33m86ac594[m clean models, controllers & views
[33mc4e115d[m feat: todas las funcionalidades menos doc
[33mbf8a3a9[m feat: mejora de pantallas
[33m13ed15f[m feat: QR && fix: devise
[33m8c4a636[m feat: completado empresas, usuarios, delegaciones
[33me582cea[m feat: modificaciones modelos y vistas
[33m91eee5c[m feat: abm de compañias
[33m9523144[m feat: modificaciones varias en modelos
[33m7b55a2c[m subo precompile
[33m1831ba6[m agrego cambiosa los users
[33m3d0fa95[m agrego cambios
[33m23398fb[m saco el cerrar sesion
[33ma517e8f[m agrego README
[33m997fc49[m arreglo los formularios de registracion
[33mf7780d8[m agrego usuarios admin y vistas
[33m5f22248[m arreglo vistas
[33ma3c241b[m fix devise
[33m8f2bbd7[m Configure local storage for Active Storage
[33m9bf0ff6[m Prepare app for deployment
[33m8451e72[m Prepare app for deployment
[33m138154b[m Fix assets precompilation for Heroku deployment
[33m395defe[m Add Linux platform to Gemfile.lock for Heroku deployment
[33m461e3c4[m Initial commit
[33mf311875[m Initial commit
