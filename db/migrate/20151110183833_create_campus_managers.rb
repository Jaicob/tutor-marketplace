class CreateCampusManagers < ActiveRecord::Migration
  def change
    create_table :campus_managers do |t|

      t.belongs_to    :user, index: true, foreign_key: true
      t.string        :profile_pic
      t.string        :phone_number
      t.integer       :status

      t.timestamps null: false
    end

    add_reference :schools, :campus_manager, index: true, foreign_key: true
    
  end
end
