class AddNamesToDeviseUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :datetime
    add_column :users, :last_name, :string
  end
end
