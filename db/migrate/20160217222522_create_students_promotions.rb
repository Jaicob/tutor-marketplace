class CreateStudentsPromotions < ActiveRecord::Migration
  def change
    create_table :students_promotions do |t|
      t.integer :student_id, null: false, index: true
      t.integer :promotion_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
