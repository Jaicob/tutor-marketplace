class CorrectDataTypeForUserFirstName < ActiveRecord::Migration
  def change
    change_column :users, :first_name,  :string
  end
end
