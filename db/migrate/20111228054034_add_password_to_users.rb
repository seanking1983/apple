class AddPasswordToUsers < ActiveRecord::Migration
  def up
    add_column :users, :encrypted_password, :string
  end
  
  def down
    remvoe_column :users, :encrypted_password
  end
end
