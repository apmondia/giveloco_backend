class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :role, :string
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :company_name, :string
  	add_column :users, :street_address, :string
    add_column :users, :phone, :string
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :country, :string
  	add_column :users, :zip, :string
    # tags are added using 'acts_as_taggable_on' gem
  	add_column :users, :summary, :text
  	add_column :users, :description, :text
  	add_column :users, :website, :string
  	add_column :users, :balance, :decimal, precision: 15, scale: 2
    add_column :users, :total_funds_raised, :decimal, precision: 15, scale: 2
  	add_column :users, :is_featured, :boolean, default: false
  	add_column :users, :supporters, :integer, array: true, default: []
  	add_column :users, :supported_causes, :integer, array: true, default: []
    add_column :users, :profile_picture_url, :string
    add_attachment :users, :profile_picture
    add_column :users, :deleted_at, :datetime

    add_index :users, :company_name, :name => "company_name_index", unique: true
  end
end
