class AddFieldsToCharge < ActiveRecord::Migration
  def up
    change_table :charges do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.string :stripe_charge_id
    end

    remove_column :charges, :customer_id, :string
  end
end
