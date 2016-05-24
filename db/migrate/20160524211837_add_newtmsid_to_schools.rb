class AddNewtmsidToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :newtms_id, :integer
  end
end
