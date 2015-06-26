class AddUserNameToUser < ActiveRecord::Migration
	def change
		# This column is no longer needed, we have first and last name
		remove_column :users, :name
		# This column is needed for Friendly_ID to work (saves slugs)
		add_column :users, :slug, :string
		add_index :users, :slug, unique: true
		# This column changes the data type for first_name, it was mistakenly set to datetime rather than string
		change_column :users, :first_name, :text
	end
