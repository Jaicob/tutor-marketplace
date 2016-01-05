class CreateCsvCourseLists < ActiveRecord::Migration
  def change
    create_table :csv_course_lists do |t|
      t.integer :school_id
      t.integer :subject_id
      t.string  :csv_file

      t.timestamps null: false
    end
  end
end
