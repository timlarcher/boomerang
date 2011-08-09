class RenameTypeInOffers < ActiveRecord::Migration
  def self.up
    rename_column :offers, :type, :bidask
  end

  def self.down
  end
end
