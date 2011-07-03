class Audit < ActiveRecord::Base

  set_table_name "audit"

  def self.audit_type ( trans_type )
    case trans_type
    when :partial_payment ; return "P"
    when :full_payment ; return "F"
    when :adjustment ; return "A"
    when :invoice_received ; return "R"
    when :invoice_matched ; return "M"
    when :auth_requested ; return "Q"
    when :auth_received ; return "C"
    when :invalid ; return "I"
    end
  end

end
