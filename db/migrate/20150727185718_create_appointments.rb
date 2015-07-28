class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|

      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :slot, index: true, foreign_key: true
      t.datetime :start_time
      t.integer :status

      t.timestamps null: false
    end
  end
end