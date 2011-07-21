class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :handle
      t.string :email
      t.string :encrypted_password
      t.string :password_salt
      t.boolean :admin, :default => false
    end
  end

  def self.down
    drop_table :users
  end
end
