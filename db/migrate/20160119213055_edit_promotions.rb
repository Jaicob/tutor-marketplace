class EditPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :single_use, :integer, default: 0
    rename_column :promotions, :category, :issuer
  end
end