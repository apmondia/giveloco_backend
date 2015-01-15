class AddSerialNumberToCertificates < ActiveRecord::Migration
  def change
    change_table :certificates do |t|
      t.string :serial_number
    end
  end
end
