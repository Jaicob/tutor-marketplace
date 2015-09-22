class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string    :code
      t.integer   :category
      t.integer   :amount
      t.date      :valid_from
      t.date      :valid_until
      t.integer   :redemption_limit
      t.integer   :redemption_count, default: 0
      t.text      :description

      t.timestamps null: false
    end

    add_reference :charges, :promotion, index: true
  end
end
