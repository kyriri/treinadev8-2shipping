class CreateShippingCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_companies do |t|
      t.string :name
      t.integer :status
      t.string :legal_name
      t.string :email_domain
      t.integer :cnpj
      t.string :billing_address

      t.timestamps
    end
  end
end
