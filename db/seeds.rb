# The data can be loaded with the bin/rails db:seed command 

ShippingCompany.destroy_all
User.destroy_all

User.create!(email: 'me@email.com', password: '12345678')
User.create!(email: 'la-la@courriel.fr', password: 'croissant')

ShippingCompany.create!(name: 'Transportes Marília',
                        status: 0,
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
ShippingCompany.create!(name: 'Ibérica',
                        status: 5,
                        legal_name: 'Ibérica dos Transportes Ltda',
                        email_domain: 'iberica.com.br',
                        cnpj: 98765432101234,
                        billing_address: 'Rua da Paz, 34 - Rio Branco, AC')

p "Created #{ShippingCompany.count} shipping companies"
p "Created #{User.count} users"