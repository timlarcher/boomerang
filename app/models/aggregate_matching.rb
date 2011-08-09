require 'csv'

class AggregateMatching < ActiveRecord::Base

  set_table_name "aggregate_matching"

  def self.load_data ( filename )
    filename = "c:\\rails\\boomerang\\db\\" + filename
    CSV.foreach(filename) do |l|
      m = AggregateMatching.new
      m.payee_client_id = l[0].to_i
      m.payer_client_id = l[1].to_i
      m.amount = l[2].to_d
      m.add_or_update
    end
  end

  def self.delete_all
    AggregateMatching.all.each { |m| m.destroy }
  end

  def self.add ( invoice )
    m = AggregateMatching.new
    m.payee_client_id = invoice.payee_client_id
    m.payer_client_id = invoice.payer_client_id
    m.amount = invoice.amount
    m.add_or_update
  end

  def add_or_update
    if n = AggregateMatching.find( payee_client_id => self.payee_client_id,
                            payer_client_id => self.payer_client_id )
      n.amount += self.amount
      n.save
    else
      self.save
    end
  end

end
