class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.slot_manager :belongs_to, index: true, foreign_key: true
      t.integer :status
      t.datetime :start_time
      t.datetime :end_time
      t.integer :reservation_min
      t.integer :reservation_max

      t.timestamps null: false
    end
  end
end
