class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.belongs_to 	:created_by, :class_name => "User"		# started_by user_id
		t.belongs_to 	:accepted_by, :class_name => "User"		# accepted_by user_id
    	
		t.integer 		:trans_id
    	t.string  		:trans_type
    	t.string		:from_name
    	t.string		:to_name
    	t.decimal		:total_debt, :precision => 8, :scale => 2
    	t.decimal		:total_credit, :precision => 8, :scale => 2
    	t.decimal		:remaining_debt, :precision => 8, :scale => 2
    	t.string		:status
    	t.boolean		:active

    	t.timestamps
    end
  end
end
