#require_relative 'matching'
#require_relative 'audit'

module Matcher

private

def self.do_payoff! ( from_index )
  # from_index is the index into the stacks that contains
  # the first invoice to be paid down. We pay down the
  # invoices from from_index to the last entry in the stacks.
  # Then we pop all the entries off from the last to the
  # entry that has zero amount. Then return.
  puts "do_payoff: hooray!"
  number_of_invoices = @invoices_stack.count-1
  payoff_amount = @amounts_stack.last
  for i in from_index..number_of_invoices
    puts "do_payoff: #{i}"
    @invoices_stack[i].amount_paid += payoff_amount
    if @invoices_stack[i].amount == @invoices_stack[i].amount_paid
      @invoices_stack[i].status = 'C'
      trans_type = :full_payment
    else
      @invoices_stack[i].status = 'P'
      trans_type = :partial_payment
    end
    @invoices_stack[i].save
    a = Audit.new( :trans_type => Audit.audit_type(trans_type),
                   :invoice_id => @invoices_stack[i].id,
                   :assoc_id => "graph_id",
                   :amount => payoff_amount )
    a.save
  end
  # Truncate the stacks starting at from_index+1.
  @payees_stack.slice!( from_index+1..number_of_invoices )
  @invoices_stack.slice!( from_index+1..number_of_invoices )
  @amounts_stack.slice!( from_index+1..number_of_invoices )
  @queries_stack.slice!( from_index+1..number_of_invoices )
end # do_payoff!


public

def self.do_match ( client_id )

  @payees_stack = []
  @invoices_stack = []
  @amounts_stack = []
  @queries_stack = []
  lowest_amount = 0.0

  lid = client_id
  current_query = Matching.where( "payee_client_id = ? and status != 'C'", lid )
  current_invoice = current_query.pop or nil

  loop do
    while current_invoice == nil
      if @queries_stack.empty?
        puts( "do_match: out of invoices for client #{lid} - quitting." )
        return
      else
        puts( "do_match: in first else." )
        lid = @payees_stack.pop
        old_invoice = @invoices_stack.pop
        current_query = @queries_stack.pop
        current_invoice = current_query.pop
        lowest_amount = @amounts_stack.pop
      end
    end

    @payees_stack.push( current_invoice.payee_client_id )
    @invoices_stack.push( current_invoice )
    @queries_stack.push( current_query )
    net_invoice_amount = current_invoice.amount - current_invoice.amount_paid
    lowest_amount = net_invoice_amount if net_invoice_amount < lowest_amount or lowest_amount == 0.0
    puts "current_invoice.amount: #{current_invoice.amount}"
    puts "current_invoice.amount_paid: #{current_invoice.amount_paid}"
    puts "lowest_amount: #{lowest_amount}"
    @amounts_stack.push( lowest_amount )

    # Remember that this might need to get moved to before the above pushes.
    i = @payees_stack.find_index( current_invoice.payer_client_id )
    puts "do_match: i: #{i}"
    puts "do_match: i is nil" if i == nil
    if i != nil and @invoices_stack[i].status != "C"
      puts "do_match: calling do_payoff."
      self.do_payoff!(i)
      current_invoice = nil
    else
      puts( "do_match: in second else." )
      lid = current_invoice.payer_client_id
      current_query = Matching.where( "payee_client_id = ? and status != 'C'", lid )
      current_invoice = current_query.pop or nil
    end
  end # loop do

end # do_match

end # class Matcher
