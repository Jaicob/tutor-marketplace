class ChangeChargeAmountToFloat < ActiveRecord::Migration
  def up
    change_column :charges, :amount, :float
    change_column :charges, :axon_fee, :float
    change_column :charges, :tutor_fee, :float
  end
  def down
    change_column :charges, :amount, :integer
    change_column :charges, :axon_fee, :integer
    change_column :charges, :tutor_fee, :integer
  end
end
