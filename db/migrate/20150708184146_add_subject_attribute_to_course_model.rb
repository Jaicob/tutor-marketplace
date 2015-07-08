class AddSubjectAttributeToCourseModel < ActiveRecord::Migration
  def change
    add_column :courses, :subject, :integer
  end
end
