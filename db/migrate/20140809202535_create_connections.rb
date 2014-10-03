class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
    	t.string        :trans_type
        t.belongs_to    :trans, :class_name => "Transaction", :foreign_key => "trans_id"
    	t.belongs_to 	:from_connection, :class_name => "User", :foreign_key => "from_connection_id"
        t.belongs_to    :to_connection, :class_name => "User", :foreign_key => "to_connection_id"
        t.integer       :total_transactions, default: 1
        t.decimal       :connection_balance, :precision => 8, :scale => 2
        t.boolean		:is_active, default: true

    	t.timestamps
    end

    add_index :connections, :id

  end
end
