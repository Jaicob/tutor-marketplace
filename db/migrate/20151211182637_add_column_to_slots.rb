class AddColumnToSlots < ActiveRecord::Migration
  def change
    add_column :slots, :slot_type, :integer, default: 0
  end
end
