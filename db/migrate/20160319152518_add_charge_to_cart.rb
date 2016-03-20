class AddChargeToCart < ActiveRecord::Migration
  def change
    add_column :carts, :charge_id, :integer
  end
end