class RemoveSubjectKeysOnCourse < ActiveRecord::Migration
  def change
    # remove_reference :courses, :subject, index: true
  end
end