class AddMorePaymentFieldsToTutor < ActiveRecord::Migration
  def change
    
    add_column :tutors, :line1, :string
    add_column :tutors, :line2, :string
    add_column :tutors, :city, :string
    add_column :tutors, :state, :string
    add_column :tutors, :postal_code, :string
    add_column :tutors, :ssn_last_4, :string
    add_column :tutors, :acct_id, :string

  end
end