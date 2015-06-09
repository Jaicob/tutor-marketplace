class AddAttachmentProfilePicToTutors < ActiveRecord::Migration
  def self.up
    change_table :tutors do |t|
      t.attachment :profile_pic
    end
  end

  def self.down
    remove_attachment :tutors, :profile_pic
  end
end
