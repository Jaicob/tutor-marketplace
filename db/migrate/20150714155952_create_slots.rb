class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|

      t.belongs_to    :slot_manager, index: true, foreign_key: true
      t.integer       :status, default: 0
      t.datetime      :start_time
      t.datetime      :end_time
      t.integer       :reservation_min
      t.integer       :reservation_max

      t.timestamps null: false
    end
  end
end
