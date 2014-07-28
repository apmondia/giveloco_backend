class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :role, :string
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :company_name, :string
  	add_column :users, :street_address, :string
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :country, :string
  	add_column :users, :zip, :string
  	add_column :users, :tags, :text, array: true, default: []
  	add_column :users, :summary, :text
  	add_column :users, :description, :text
  	add_column :users, :website, :string
  	add_column :users, :balance, :decimal, precision: 15, scale: 2
  	add_column :users, :total_debits, :integer
  	add_column :users, :total_debits_value, :decimal, precision: 15, scale: 2
  	add_column :users, :total_credits, :integer
  	add_column :users, :total_credits_value, :decimal, precision: 15, scale: 2
  	add_column :users, :is_featured, :boolean
  	add_column :users, :supporters, :integer, array: true, default: []
  	add_column :users, :supported_causes, :integer, array: true, default: []
  end
end