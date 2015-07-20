class AddStartWeekTimeAndEndWeekTimeToSlot < ActiveRecord::Migration
  def change
    add_column :slots, :start_dow_time, :string
    add_column :slots, :end_dow_time, :string
  end
end
