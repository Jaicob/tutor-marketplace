class AddTranscriptToTutors < ActiveRecord::Migration
  def change
    add_column :tutors, :transcript, :string
    remove_column :tutors, :transcript_file_name
    remove_column :tutors, :transcript_content_type
    remove_column :tutors, :transcript_file_size
    remove_column :tutors, :transcript_updated_at
  end
end
