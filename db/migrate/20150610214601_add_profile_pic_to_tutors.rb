class AddProfilePicToTutors < ActiveRecord::Migration
	def change
		add_column :tutors, :profile_pic, :string
	end
