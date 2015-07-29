class AddSchoolToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|

      t.belongs_to :school, index: true, foreign_key: true

    end
  end
end