class AddAttachmentTranscriptToTutors < ActiveRecord::Migration
  def self.up
    change_table :tutors do |t|
      t.attachment :transcript
    end
  end

  def self.down
    remove_attachment :tutors, :transcript
  end
end
