class SetDefaultStatusForTutors < ActiveRecord::Migration
  def change
    change_column_default :tutors, :status, 0
  end
end
