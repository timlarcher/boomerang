module MatchingHelper

  # Go through parameter and find the smallest unpaid amount.
  def payoff_amount ( matching_list )
    lowest_amount = matching_list[0].amount - matching_list[0].amount_paid
    matching_list.each do |m|
      amt = m.amount - m.amount_paid
      lowest_amount = amt if amt < lowest_amount
    end
    lowest_amount
  end

end
