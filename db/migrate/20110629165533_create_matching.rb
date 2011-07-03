class CreateMatching < ActiveRecord::Migration
  def self.up
    create_table :matching do |t|
      t.integer :payee_client_id, :null => false
      t.integer :payer_client_id, :null => false
      t.decimal :amount, :null => false
      t.string  :status, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :matching
  end
end
