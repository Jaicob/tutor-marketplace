class AddChargeReferenceToAppointments < ActiveRecord::Migration
  def change
    add_reference :appointments, :charge, index: true, foreign_key: true
  end
end
