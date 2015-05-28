class CreateTutorCourses < ActiveRecord::Migration
  def change
    create_table :tutor_courses do |t|
      t.references :tutor, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.integer :rate

      t.timestamps null: false
    end
  end
end
