class AddTimestampsToPromotion < ActiveRecord::Migration
  def change
    add_timestamps :promotions
  end
end
