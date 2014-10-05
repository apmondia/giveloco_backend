class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
    	t.string        :trans_type
    	t.belongs_to 	:from_user, :class_name => "User", :foreign_key => "from_user_id"
        t.belongs_to    :to_user, :class_name => "User", :foreign_key => "to_user_id"
        t.string        :from_name
        t.string        :to_name
        t.integer       :total_transactions, default: 0
        t.decimal       :connection_balance, :precision => 8, :scale => 2, default: 0.00
        t.boolean		:is_active, default: true

    	t.timestamps
    end

    add_index :connections, :id

  end
end
