class Addamounttoinvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :amount, :decimal
  end

  def self.down
    drop_column :invoices, :amount
  end
end
