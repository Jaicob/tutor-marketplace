class AddCustomerIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :customer_id, :string
    add_column :students, :last_4_digits, :string
  end
end
