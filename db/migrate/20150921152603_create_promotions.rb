class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :code
      t.integer :type
      t.integer :amount
      t.date :valid_from
      t.date :valid_until
      t.integer :redemption_limit
      t.integer :redemption_count

      t.timestamps null: false
    end
  end
end
