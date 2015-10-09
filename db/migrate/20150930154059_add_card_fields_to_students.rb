class AddCardFieldsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :card_brand, :string
  end
end
