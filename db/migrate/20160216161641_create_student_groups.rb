class CreateStudentGroups < ActiveRecord::Migration
  def change
    create_table :student_groups do |t|
      t.string :name
      t.integer :status
      t.belongs_to :school

      t.timestamps null: false
    end

    add_index :student_groups, :school_id

    add_column :students, :student_group_id, :integer
    add_index  :students, :student_group_id

    add_column :promotions, :student_group_id, :integer

    add_column :promotions, :student_id, :integer
  end
end