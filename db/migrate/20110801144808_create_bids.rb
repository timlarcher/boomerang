class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.integer  "client_id"
      t.integer  "user_id"
      t.integer  "quantity"
      t.integer  "amount"
      t.boolean  "closed",     :default => false
      t.timestamps
    end

    remove_column :offers, :bidask

  end

  def self.down
    drop_table :bids
  end
end
