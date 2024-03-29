class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|

      t.belongs_to  :user, index: true, foreign_key: true
      t.belongs_to  :school, index: true, foreign_key: true
      t.string      :phone_number

      t.timestamps null: false
    end
  end
end
