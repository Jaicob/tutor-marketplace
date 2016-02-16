class EditPromotionModel < ActiveRecord::Migration
  def change
    rename_column :promotions, :single_appt, :reedemer_restrictions
    remove_column :promotions, :student_uniq
  end
end
