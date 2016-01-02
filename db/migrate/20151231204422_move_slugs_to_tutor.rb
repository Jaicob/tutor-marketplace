class MoveSlugsToTutor < ActiveRecord::Migration
  def change
    add_column  :tutors, :slug,  :string
    add_index   :tutors, :slug,  unique: true

    remove_column :users, :slug,  :string
  end
end
