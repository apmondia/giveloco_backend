class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
        t.integer       :trans_id
        t.integer       :stripe_id
        t.string        :trans_type

    	t.belongs_to 	:from_user, :class_name => "User", :foreign_key => "from_user_id"
        t.belongs_to    :to_user, :class_name => "User", :foreign_key => "to_user_id"
        t.string        :from_name
        t.string        :to_name
        t.string        :from_user_role
        t.string        :to_user_role
        t.decimal       :amount, :precision => 8, :scale => 2
    	t.string		:status
        t.datetime      :cancelled_at
        t.datetime      :completed_at
        t.boolean       :is_complete, default: false

    	t.timestamps
    end

    add_index :transactions, :trans_id, :name => "trans_id_index", unique: true
    add_index :transactions, :from_user_id, :name => "from_user_id_index"
    add_index :transactions, :to_user_id, :name => "to_user_id_index"

  end
end
