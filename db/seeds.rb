# The data can be loaded with the bin/rails db:seed command 

Quote.destroy_all
DeliveryTime.destroy_all
ShippingRate.destroy_all
ServiceOrder.destroy_all
Outpost.destroy_all
User.destroy_all
Package.destroy_all
ShippingCompany.destroy_all

sc1 = ShippingCompany.create!(status: 'active',
                              name: 'Air Cargo',
                              legal_name: 'Empresa Brasileira de Transporte de Cargas Ltda',
                              email_domain: 'aircargo.com.br',
                              cnpj: 54321678900011,
                              billing_address: 'Av. Atlântica, Rio de Janeiro - RJ',
                              cubic_weight_const: 600,
                              min_fee: 45
                             )
sc2 = ShippingCompany.create!(status: 'active',
                              name: 'Cheirex',
                              legal_name: 'Transportes Federais do Brasil S.A.',
                              email_domain: 'cheirex.com',
                              cnpj: 12345678901234,
                              billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP',
                              cubic_weight_const: 35,
                              min_fee: 8,
                             )
sc3 = ShippingCompany.create!(status: 'active',
                              name: 'Ibérica',
                              legal_name: 'Ibérica dos Transportes Ltda',
                              email_domain: 'iberica.com.br',
                              cnpj: 98765432101234,
                              billing_address: 'Rua da Paz, 34 - Rio Branco, AC',
                              cubic_weight_const: 30,
                              min_fee: 10,
                             )
sc4 = ShippingCompany.create!(status: 'in_registration', 
                              name: 'Granelero',
                              legal_name: 'Transportes Graneleros do Brasil S.A.',
                              email_domain: 'br.granelero.com',
                              cnpj: 34259054000134,
                              billing_address: 'Rua da Paz, 34 - Rio Branco, AC',
                              cubic_weight_const: 20,
                              min_fee: 10,
                             )
sc5 = ShippingCompany.create!(status: 'deleted',
                              name: 'Transportes Marília',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tma.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP',
                             )
complete_package1 = Package.create!(width_in_cm: 14,
                                    height_in_cm: 6,
                                    length_in_cm: 21,
                                    volume_in_m3: Float(14 * 6 * 21)/1_000_000,
                                    weight_in_g: 250,
                                    distance_in_km: 800,
                                    pickup_address: 'Galpão TFD - Rodovia Dutra km3, Guarulhos - SP',
                                    delivery_address: 'Av. do Contorno 354 - Belo Horizonte, MG',
                                    delivery_recipient_name: 'José Magela Amorim',
                                    delivery_recipient_phone: '(31) 9 9453-8890',
                                  )
complete_package2 = Package.create!(width_in_cm: 100,
                                    height_in_cm: 86,
                                    length_in_cm: 35,
                                    volume_in_m3: Float(100 * 86 * 35)/1_000_000,
                                    weight_in_g: 1_250,
                                    distance_in_km: 12,
                                    pickup_address: 'Av. Interlagos, 2.350',
                                    delivery_address: 'Av. Corifeu de Azevedo Marques, 251 / 81',
                                    delivery_recipient_name: 'Carla Callegari',
                                    delivery_recipient_phone: '(11) 9 8431-9106',
                                  )
complete_package3 = Package.create!(width_in_cm: 10,
                                    height_in_cm: 4,
                                    length_in_cm: 22,
                                    volume_in_m3: Float(10 * 4 * 22)/1_000_000,
                                    weight_in_g: 182,
                                    distance_in_km: 12,
                                    pickup_address: 'Av. Interlagos, 2.350',
                                    delivery_address: 'Av. Corifeu de Azevedo Marques, 251 / 81',
                                    delivery_recipient_name: 'Carla Callegari',
                                    delivery_recipient_phone: '(11) 9 8431-9106',
                                  )
simple_package1 = Package.create!(volume_in_m3: 0.0034, weight_in_g: 182, distance_in_km: 12)
simple_package2 = Package.create!(volume_in_m3: 0.0017, weight_in_g: 500, distance_in_km: 50)
simple_package3 = Package.create!(volume_in_m3: 0.001, weight_in_g: 20, distance_in_km: 273)
simple_package4 = Package.create!(volume_in_m3: 0.004, weight_in_g: 1750, distance_in_km: 800)
simple_package5 = Package.create!(volume_in_m3: 0.0105, weight_in_g: 3276, distance_in_km: 39)

                
ServiceOrder.create!(status: 'unassigned', package: simple_package1)
ServiceOrder.create!(status: 'unassigned', package: simple_package2)
ServiceOrder.create!(status: 'rejected', package: simple_package3, shipping_company: sc2)
serv_order1 = ServiceOrder.create!(status: 'pending', package: complete_package1, shipping_company: sc2)
serv_order2 = ServiceOrder.create!(status: 'pending', package: complete_package2, shipping_company: sc2)
serv_order3 = ServiceOrder.create!(status: 'accepted', package: complete_package3, shipping_company: sc2)
ServiceOrder.create!(status: 'canceled', package: simple_package4)
ServiceOrder.create!(status: 'delivered', package: simple_package5)

ShippingRate.create!(max_weight_in_kg: 0.3, cost_per_km_in_cents: 50, shipping_company: sc3)
ShippingRate.create!(max_weight_in_kg: 0.5, cost_per_km_in_cents: 55, shipping_company: sc3)
ShippingRate.create!(max_weight_in_kg: 1  , cost_per_km_in_cents: 60, shipping_company: sc3)
ShippingRate.create!(max_weight_in_kg: 5  , cost_per_km_in_cents: 65, shipping_company: sc3)

ShippingRate.create!(max_weight_in_kg: 1, cost_per_km_in_cents: 55, shipping_company: sc2)
ShippingRate.create!(max_weight_in_kg: 0.3, cost_per_km_in_cents: 52, shipping_company: sc2)
ShippingRate.create!(max_weight_in_kg: 7, cost_per_km_in_cents: 50, shipping_company: sc2)

Quote.create!(fee: 21.24, delivery_time: 2, chosen: true, quote_group: "WYV-UUG", shipping_company: sc2, service_order: serv_order1, is_valid: true)
Quote.create!(fee: 27.24, delivery_time: 1, chosen: true,  quote_group: "90A-P4B", shipping_company: sc2, service_order: serv_order2, is_valid: true)
Quote.create!(fee: 10.00, delivery_time: 3, chosen: true,  quote_group: "MNH-BL0", shipping_company: sc2, service_order: serv_order3, is_valid: true)

DeliveryTime.create!(max_distance_in_km: 400, delivery_time_in_buss_days: 4, shipping_company: sc2)
DeliveryTime.create!(max_distance_in_km: 800, delivery_time_in_buss_days: 3, shipping_company: sc2)
DeliveryTime.create!(max_distance_in_km: 50, delivery_time_in_buss_days: 2, shipping_company: sc2)
DeliveryTime.create!(max_distance_in_km: 20, delivery_time_in_buss_days: 1, shipping_company: sc2)
DeliveryTime.create!(max_distance_in_km: 150, delivery_time_in_buss_days: 3, shipping_company: sc2)
DeliveryTime.create!(max_distance_in_km: 555, delivery_time_in_buss_days: 8, shipping_company: sc3) # another company

Outpost.create!(shipping_company: sc2, name: 'Zona Sul', city_state: 'São Paulo, SP', category: 'centro de coleta')
Outpost.create!(shipping_company: sc2, name: 'Aeroporto', city_state: 'Guarulhos, SP', category: 'centro de envios aéreos')
Outpost.create!(shipping_company: sc2, name: 'Aeroporto', city_state: 'Confins, MG', category: 'centro de envios aéreos')
Outpost.create!(shipping_company: sc2, name: 'Pampulha', city_state: 'Belo Horizonte, MG', category: 'centro de distribuição')
Outpost.create!(shipping_company: sc2, name: 'Savassi', city_state: 'Belo Horizonte, MG', category: 'posto de entrega')
Outpost.create!(shipping_company: sc3, name: 'Foro', city_state: 'Teresina, PI', category: 'regional II')
    
User.create!(email: 'user@email.com', password: '123456', shipping_company: sc2)
User.create!(email: 'admin@email.com', password: '123456', admin: true)
User.create!(email: 'la-la@courriel.fr', password: 'croissant')

p "Created #{ShippingCompany.count} shipping companies"
p "Created #{User.count} users"
p "Created #{Package.count} packages"
p "Created #{ServiceOrder.count} service orders"
p "Created #{Quote.count} quotes"
p "Created price table for #{ShippingRate.select(:shipping_company_id).distinct.count} shipping companies"
p "Created delivery times table for #{DeliveryTime.select(:shipping_company_id).distinct.count} shipping companies"
p "Created #{Outpost.count} outposts for #{Outpost.select(:shipping_company_id).distinct.count} shipping companies"
