class UpdatePromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :student_id, :integer
    add_column :promotions, :single_appt, :integer
    rename_column :promotions, :single_use, :repeat_use
    add_column :promotions, :redeemer, :integer

    add_index :promotions, :student_id
  end
end