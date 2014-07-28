class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.belongs_to :user
    	t.integer :user_id
    	t.integer :trans_id
    	t.string :trans_type

    	t.timestamps
    end
  end
end
