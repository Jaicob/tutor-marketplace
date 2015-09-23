class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      
      t.integer     :amount
      t.integer     :axon_fee
      t.integer     :tutor_fee
      t.string      :customer_id
      t.references  :tutor, index: true, foreign_key: true
      t.string      :token

      t.timestamps null: false
    end
  end
end
