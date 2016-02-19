class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to  :appointment, index: true, null: false
      t.integer     :rating
      t.text        :comment
      t.integer     :follow_up

      t.timestamps null: false
    end
  end
end
