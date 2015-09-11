class AddSignInIpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sign_in_ip, :string
  end
end
