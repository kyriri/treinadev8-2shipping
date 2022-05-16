require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  describe 'is not valid when' do
    it 'mandatory fields are blank' do
      cia = ShippingCompany.new(name: '',
                                legal_name: '',
                                cnpj: '',
                                status: '',
                                email_domain: '',
                                billing_address: '')
      
      cia.valid?

      expect(cia.errors.full_messages).to include('nome fantasia não pode ficar em branco')
      expect(cia.errors.full_messages).to include('razão social não pode ficar em branco')
      expect(cia.errors.full_messages).to include('CNPJ não pode ficar em branco')
      expect(cia.errors.full_messages).to include('status não pode ficar em branco')
      expect(cia.errors.full_messages).to include('domínio de email não pode ficar em branco')
      expect(cia.errors.full_messages).to include('endereço de faturamento não pode ficar em branco')
    end

    it 'unique fields are repeated' do
      ShippingCompany.create!(name: 'Transportes Marília',
                              status: 'active',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tma.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
      cia = ShippingCompany.new(name: 'Transportes Marília',
                                cnpj: 12345678904321)

      cia.valid?

      expect(cia.errors.full_messages).to include('nome fantasia já está em uso')
      expect(cia.errors.full_messages).to include('CNPJ já está em uso')
    end

    it 'numerical fields receive other characers' do
      cia = ShippingCompany.new(cnpj: '123456-8904321')

      cia.valid?

      expect(cia.errors.full_messages).to include('CNPJ deve conter apenas números')
    end

    it 'fields with specific length are not respected' do
      cia = ShippingCompany.new(cnpj: 1)

      cia.valid?

      expect(cia.errors.full_messages).to include('CNPJ deve ter 14 números')
    end
  end

  describe 'is valid when' do
    it 'name is repeated from a deleted company' do
      ShippingCompany.create!(name: 'Transportes Marília',
                              status: 'deleted',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tam.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
    
      cia = ShippingCompany.new(name: 'Transportes Marília',
                                    status: 'in_registration',
                                    legal_name: 'Transportes Marília Ltda',
                                    email_domain: 'tam2022.com.br',
                                    cnpj: 12345678900001,
                                    billing_address: 'Av. do Aeroporto, 10 - Rio de Janeiro, RJ')
      expect(cia.valid?).to be true
    end

    it 'cnpj is repeated from a deleted company' do
      ShippingCompany.create!(name: 'Transportes Marília',
                              status: 'deleted',
                              legal_name: 'Transportes Marília Ltda',
                              email_domain: 'tam.com.br',
                              cnpj: 12345678904321,
                              billing_address: 'Av. Getúlio Vargas, 32 - Marília, SP')
    
      cia = ShippingCompany.new(name: 'Transportes Cardoso',
                                    status: 'in_registration',
                                    legal_name: 'Transportes Cardoso Ltda',
                                    email_domain: 'cardoso.com.br',
                                    cnpj: 12345678904321,
                                    billing_address: 'Av. do Aeroporto, 10 - Rio de Janeiro, RJ')
      expect(cia.valid?).to be true
    end
  end
end
