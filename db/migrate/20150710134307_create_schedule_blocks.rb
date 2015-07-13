class CreateScheduleBlocks < ActiveRecord::Migration
  def change
    create_table :schedule_blocks do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status, default: 0
      t.integer :reservation_min
      t.integer :reservation_max
      t.references :tutor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
