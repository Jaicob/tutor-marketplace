class AddLast4AcctToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :last_4_acct, :string
  end
end
