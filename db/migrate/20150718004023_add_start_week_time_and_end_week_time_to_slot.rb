class AddStartWeekTimeAndEndWeekTimeToSlot < ActiveRecord::Migration
  def change
    add_column :slots, :start_week_time, :string
    add_column :slots, :end_week_time, :string
  end
end
