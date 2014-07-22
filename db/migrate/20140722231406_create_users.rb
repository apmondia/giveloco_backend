class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :type
      t.text :first_name
      t.text :last_name
      t.text :company_name
      t.text :email
      t.text :password
      t.text :password_salt
      t.text :street_address
      t.text :city
      t.text :state
      t.text :country
      t.text :zip
      t.text :tags
      t.text :summary
      t.text :description
      t.text :website      
      t.decimal :balance, precision: 15, scale: 2
      t.integer :total_debits
      t.decimal :total_debits_value, precision: 15, scale: 2
      t.integer :total_credits
      t.decimal :total_credits_value, precision: 15, scale: 2
      t.boolean :is_featured
      t.integer :supporters
      t.integer :supported_causes
      t.integer :vouchers
      t.integer :transactions
      t.integer :redemptions
      t.boolean :is_authenticated
      t.attachment :profile_picture
      t.datetime :last_login

      t.timestamps
    end
  end
end
