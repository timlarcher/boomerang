class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :payee_client_id
      t.integer :payer_client_id
      t.string  :invoice_number
      t.date    :invoice_date
      t.string  :po_number
      t.date    :po_date
      t.string  :memo
      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
