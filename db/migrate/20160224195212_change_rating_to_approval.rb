class ChangeRatingToApproval < ActiveRecord::Migration
  def change
    rename_column :tutors, :rating, :approval
  end
end
