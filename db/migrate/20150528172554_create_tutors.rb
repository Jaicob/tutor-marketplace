class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      
      t.belongs_to  :user, index: true, foreign_key: true
      t.integer     :active_status, default: 0
      t.integer     :application_status, default: 0
      t.integer     :rating
      t.integer     :degree, default: 0
      t.integer     :degree_2
      t.integer     :degree_3 
      t.string      :major
      t.string      :major_2
      t.string      :major_3
      t.text        :extra_info_1
      t.text        :extra_info_2
      t.text        :extra_info_3
      t.string      :graduation_year
      t.string      :phone_number
      t.date        :birthdate
      t.string      :profile_pic
      t.string      :transcript
      t.text        :appt_notes
      t.boolean     :courses_approved, default: false

      t.timestamps null: false
    end
  end
end