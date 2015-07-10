class AddDefaultStatusToScheduleBlocks < ActiveRecord::Migration
  def change
    change_column :schedule_blocks, :status, :integer, default: 0
  end
end