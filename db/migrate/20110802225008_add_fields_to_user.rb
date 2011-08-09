class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :accept_bids, :boolean, :default => false
    add_column :users, :make_bids, :boolean, :default => false
    add_column :users, :accept_offers, :boolean, :default => false
    add_column :users, :make_offers, :boolean, :default => false
    User.update_all [ "accept_bids = ?", false ]
    User.update_all [ "make_bids = ?", false ]
    User.update_all [ "accept_offers = ?", false ]
    User.update_all [ "make_offers = ?", false ]
  end

  def self.down
  end
end
