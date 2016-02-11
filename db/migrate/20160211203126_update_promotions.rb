class UpdatePromotions < ActiveRecord::Migration
  def change
    rename_column :promotions, :single_use, :single_appt
    add_column :promotions, :student_uniq, :integer, default: 0
  end
end
