include SessionsHelper

module UsersHelper

  def can_accept_bids?
    redirect_to root_path unless current_user.accept_bids
  end

  def can_make_bids?
    redirect_to root_path unless current_user.make_bids
  end

  def can_accept_offers?
    redirect_to root_path unless current_user.accept_offers
  end

  def can_make_offers?
    redirect_to root_path unless current_user.make_offers
  end

end
