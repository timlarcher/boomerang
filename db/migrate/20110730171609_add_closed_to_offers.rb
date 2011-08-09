class AddClosedToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :closed, :boolean
  end

  def self.down
    remove_column :offers, :closed
  end
end
