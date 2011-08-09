class Bidasks < ActiveRecord::Migration
  def self.up
    create_table :bidasks do |t|
      t.integer :client_id
      t.integer :user_id
      t.integer :quantity
      t.integer :amount
      t.string  :bidask
      t.boolean :closed, :default => false
      t.timestamps
    end
    add_index :bidask
  end

  def self.down
    drop_table :bidasks
  end
end
