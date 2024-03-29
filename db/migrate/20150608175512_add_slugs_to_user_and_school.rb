class AddSlugsToUserAndSchool < ActiveRecord::Migration
  def change

    add_column  :users, :slug,  :string
    add_index   :users, :slug,  unique: true

    add_column  :schools, :slug,  :string
    add_index   :schools, :slug,  unique: true
    
  end
end