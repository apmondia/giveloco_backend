class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Basic Info
      t.string :role
      t.string :first_name
      t.string :last_name

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :authentication_token

      ## User Location Info
      t.string  :company_name
      t.string  :street_address
      t.string  :phone
      t.string  :city
      t.string  :state
      t.string  :country
      t.string  :zip
      t.boolean :global_redeem, default: false # Gift certificates can be redeemed at all of a business' locations

      ## User Details
      t.text   :summary
      t.text   :description
      t.string :website

      ## Payment Gateway (Stripe)
      t.string  :customer_id

      ## User Financials
      t.decimal :balance,             precision: 15, scale: 2, default: 0.00
      t.decimal :total_funds_raised,  precision: 15, scale: 2, default: 0.00

      ## Account Variables
      t.boolean   :is_published, default: false
      t.boolean   :is_featured, default: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      
      ## Timestamps
      t.timestamps
      t.datetime  :deleted_at

      # tags are added using 'acts_as_taggable_on' gem
    end

    add_index :users, :id
    add_index :users, :email,                unique: true
    add_index :users, :authentication_token, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
    add_index :users, :company_name, :name => "company_name_index", unique: true
  end
end
