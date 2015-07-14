class AddSubjectNumberToCourse < ActiveRecord::Migration
  def up
    add_column :courses, :subject_number, :integer
  end

  def down
    remove_column :courses, :subject_number, :integer
  end

end
