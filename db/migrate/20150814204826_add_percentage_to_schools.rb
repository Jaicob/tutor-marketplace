class AddPercentageToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :transaction_percentage, :float
  end
end
