class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      
      t.belongs_to  :user, index: true, foreign_key: true
      t.integer     :active_status, default: 0
      t.integer     :application_status, default: 0
      t.integer     :rating
      t.string      :degree
      t.string      :major
      t.string      :extra_info
      t.string      :graduation_year
      t.string      :phone_number
      t.date        :birthdate
      t.string      :profile_pic
      t.string      :transcript
      t.string      :appt_notes

      t.timestamps null: false
    end
  end
end
