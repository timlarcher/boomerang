class CreateAudit < ActiveRecord::Migration
  def self.up
    create_table :audit do |t|
      t.string :assoc_id, :null => false
      t.string :trans_type, :null => false
      t.integer :invoice_id, :null => false
      t.decimal :amount, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :audit
  end
end
