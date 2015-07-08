class AddSubjectAttributeToCourseModel < ActiveRecord::Migration
  def change
    add_column :courses, :subjects, :integer
  end
end
