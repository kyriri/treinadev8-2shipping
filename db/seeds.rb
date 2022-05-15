# The data can be loaded with the bin/rails db:seed command 

ShippingCompany.destroy_all

ShippingCompany.create!(name: 'Transportes Marília',
                        status: 2,
                        legal_name: 'Transportes Marília Ltda',
                        email_domain: 'tma.com.br',
                        cnpj: 12345678904321,
                        billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
ShippingCompany.create!(name: 'Cheirex',
                        status: 8,
                        legal_name: 'Transportes Federais do Brasil S.A.',
                        email_domain: 'cheirex.com',
                        cnpj: 12345678901234,
                        billing_address: 'Av. das Nações Unidas, 1.532 - São Paulo, SP')

p "Created #{ShippingCompany.count} shipping companies"