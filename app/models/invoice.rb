class Invoice < ActiveRecord::Base

  attr_accessible :payee_client_id, :payer_client_id, :invoice_number,
    :invoice_date, :amount, :po_number, :po_date, :memo

  def self.load_data ( dirname, filename )
    f = dirname + filename
    CSV.foreach(f) do |l|
      i = Invoice.new
      i.payee_client_id = l[0].to_i
      i.payer_client_id = l[1].to_i
      i.invoice_number = l[2]
      i.invoice_date = l[4]
      i.amount = l[3].to_d
      i.po_number = l[5]
      i.po_date = l[6]
      i.memo = l[7]
      j = Invoice.where(
            :payee_client_id => i.payee_client_id,
            :payer_client_id => i.payer_client_id,
            :invoice_number => i.invoice_number,
            :invoice_date => i.invoice_date,
            :amount => i.amount,
            :po_number => i.po_number,
            :po_date => i.po_date )
      if j and j.first
        Matching.add( j.first )
        j.first.destroy
      else
        i.save
      end
    end
  end

  def self.base_dir
    './ftp/'
  end

  def self.in_dir ( client_id )
    self.base_dir + client_id.to_s + '/in/'
  end

  def self.out_dir ( client_id )
    self.base_dir + client_id.to_s + '/out/'
  end

  def self.delete_all
    Invoice.all.each { |i| i.destroy }
  end

end
