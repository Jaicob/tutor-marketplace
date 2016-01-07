class AddDobToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :dob, :date
  end
end
