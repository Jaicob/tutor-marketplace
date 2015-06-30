class AddTranscriptToTutors < ActiveRecord::Migration
  def change
    add_column :tutors, :transcript, :string
  end
end
