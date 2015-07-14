class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :role, :integer, default: 0
    add_column :tutors, :profile_pic, :string
    add_column :tutors, :transcript, :string
  end
end
