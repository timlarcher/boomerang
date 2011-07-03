class AddAmountPaidToMatching < ActiveRecord::Migration
  def self.up
    add_column :matching, :amount_paid, :decimal
  end

  def self.down
    remove_column :matching, :amount_paid
  end
end
