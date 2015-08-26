class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      
      t.belongs_to  :school, index: true, foreign_key: true
      t.belongs_to  :subject, index: true, foreign_key: true
      t.string      :call_number
      t.string      :friendly_name
      
      t.timestamps null: false
    end
  end
end
