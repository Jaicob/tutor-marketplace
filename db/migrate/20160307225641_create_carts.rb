class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.text :checkout_hash

      t.timestamps null: false
    end
  end
end
