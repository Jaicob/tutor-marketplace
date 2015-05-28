class MoveSchoolModel < ActiveRecord::Migration
  def change
    # Remove school_id from tutors table, as well as keys
    remove_reference(:tutors, :school, index: true, foreign_key: true)
    # Add school_id to courses table, as well as keys
    add_reference(:courses, :school, index: true, foreign_key: true)
  end
end
