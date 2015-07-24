class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|

      t.belongs_to    :tutor, index: true, foreign_key: true
      t.integer       :status, default: 0
      t.datetime      :start_time
      t.integer       :duration
      t.integer       :reservation_min
      t.integer       :reservation_max

      t.timestamps null: false
    end
  end
end
