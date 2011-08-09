class AddDefaultToClosed < ActiveRecord::Migration
  def self.up
    change_column :offers, :closed, :boolean, :default => false
  end

  def self.down
  end
end
