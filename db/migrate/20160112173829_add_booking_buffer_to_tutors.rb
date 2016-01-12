class AddBookingBufferToTutors < ActiveRecord::Migration
  def change
    add_column :tutors, :booking_buffer, :integer, default: 6
  end
end