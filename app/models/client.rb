class Client < ActiveRecord::Base

  has_many :users
  has_many :offers
  has_many :bids

end
