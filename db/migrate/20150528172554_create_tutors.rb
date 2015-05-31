class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.references :school, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :rating
      t.integer :status
      t.date :birthdate
      t.string :degree
      t.string :major
      t.string :extra_info
      t.string :graduation_year
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
