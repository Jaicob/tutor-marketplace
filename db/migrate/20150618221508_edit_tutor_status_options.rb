class EditTutorStatusOptions < ActiveRecord::Migration
  def change
    rename_column :tutors, :status, :application_status
    add_column :tutors, :active_status, :integer, default: 0
  end
end
