class AddAdminNotesToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :follow_up_notes, :text
    rename_column :reviews, :follow_up, :follow_up_status
  end
end
