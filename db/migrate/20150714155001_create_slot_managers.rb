class CreateSlotManagers < ActiveRecord::Migration
  def change
    create_table :slot_managers do |t|
      
      t.belongs_to  :tutor, index: true, foreign_key: true
      t.date        :start_date
      t.date        :end_date
      t.boolean     :is_recurring, default: true
      t.text        :exclusions

      t.timestamps null: false
    end
  end
end
