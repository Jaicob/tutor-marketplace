class EditPromotionModel < ActiveRecord::Migration
  def change
    rename_column :promotions, :student_uniq, :single_use
  end
end
