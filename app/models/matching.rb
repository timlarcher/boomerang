require 'csv'

class Matching < ActiveRecord::Base

  set_table_name "matching"

  def self.load_data ( filename )
    Matching.all.each { |m| m.destroy }
    filename = "c:\\rails\\boomerang\\db\\" + filename
    CSV.foreach(filename) do |l|
      m = Matching.new
      m.payee_client_id = l[0].to_i
      m.payer_client_id = l[1].to_i
      m.amount = l[2].to_d
      m.amount_paid = l[3].to_d
      m.status = l[4]
      m.save
    end
  end

end
