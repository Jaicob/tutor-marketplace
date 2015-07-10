class CreateScheduleBlocks < ActiveRecord::Migration
  def change
    create_table :schedule_blocks do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :status
      t.integer :reservaton_min
      t.integer :reservation_max
      t.references :tutor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
